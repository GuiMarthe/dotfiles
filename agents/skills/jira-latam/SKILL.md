---
name: jira-latam
description: Gestionar tickets de Jira en projectmanagement.appslatam.com, sincronizar datos desde EMA, y enviar recordatorios semanales a Google Chat. Use when user mentions Jira LATAM, experiments, EMA sync, eLoyalty, or LATAM ticket management.
---

# Jira LATAM

Asistente para gestionar tickets de Jira en `projectmanagement.appslatam.com`.

Usa los MCP tools `mcp__jira-latam__*` para todas las operaciones. Si el usuario no especifica qué hacer, pregunta qué ticket o búsqueda necesita.

## Setup

Instalar dependencias (una sola vez):

```bash
pip3 install -r scripts/requirements.txt
```

Configurar credenciales:

```bash
cp scripts/.env.example scripts/.env
# Editar scripts/.env con tus datos
```

> **Nota:** los paths de scripts son relativos a este skill directory. Resolverlos contra el directorio padre de este SKILL.md.

## MCP tools disponibles

- `jira_searchIssues` — buscar con JQL
- `jira_getIssue` — ver detalle de un ticket
- `jira_updateIssue` — actualizar campos (los que no están en pantalla de transición)
- `jira_transitionIssue` — cambiar estado; pasar `fields` para campos obligatorios de la pantalla
- `jira_getTransitions` — consultar transiciones disponibles desde el estado actual
- `jira_createIssue` — crear ticket
- `jira_postIssueComment` — agregar comentario

## Patrón para actualizar N tickets con los mismos valores

1. Avanzar el ticket base estado a estado, recopilando campos obligatorios
2. Replicar en paralelo a los demás tickets con los mismos valores
3. Si los campos no están en la pantalla de transición, usar `jira_updateIssue` en paralelo con `jira_transitionIssue`
4. Los tickets recién clonados parten en **Created** — pueden necesitar pasos intermedios antes de llegar al estado destino

## Descubrir campos requeridos de una transición

Intentar la transición sin campos; el error 400 devuelve exactamente qué `customfield_XXXXX` son obligatorios.

---

## Custom fields frecuentes

| Nombre | Field ID | Tipos |
|--------|----------|-------|
| Story Points | `customfield_10106` | Tarea |
| Epic Link | `customfield_10100` | Experimento, Tarea |
| Parent Link | `customfield_16006` | Experimento, Tarea, Epic |
| Domain | `customfield_62001` | Experimento |
| Target Group | `customfield_60006` | Experimento |
| Amount of units | `customfield_60007` | Experimento |
| Reviewer | `customfield_57105` | Experimento |
| Secondary metrics | `customfield_57401` | Experimento |
| Break glass / Guardrail metric | `customfield_57204` | Experimento |
| Primary Metric (Insight) | `customfield_57601` | Experimento |
| Primary Metric Logic | `customfield_64501` | Experimento |
| Assumptions | `customfield_57008` | Experimento |
| Intervention | `customfield_57102` | Experimento |
| Expected output | `customfield_57103` | Experimento |
| Null Hypothesis | `customfield_57206` | Experimento |
| Alternative Hypothesis | `customfield_57207` | Experimento |
| Significance level | `customfield_57208` | Experimento |
| Power | `customfield_57209` | Experimento |
| Runtime (days) | `customfield_57211` | Experimento |
| Analysis platform URL | `customfield_57600` | Experimento |
| Result | `customfield_57403` | Experimento |
| Winning Variant | `customfield_57404` | Experimento |
| Result uplift | `customfield_57405` | Experimento |
| Result Upper Bound | `customfield_57406` | Experimento |
| Result Lower Bound | `customfield_57407` | Experimento |
| Relative or absolute uplift | `customfield_59300` | Experimento |
| Next steps | `customfield_62105` | Experimento |
| Iteration Plan | `customfield_62106` | Experimento |
| Learnings | `customfield_68402` | Experimento |
| Result conclusion | `customfield_18401` | Experimento |
| Related experiment NEW | `customfield_71000` | Experimento |
| KPI Base | `customfield_16304` | Epic |
| KPI Baseline | `customfield_30400` | Epic |
| KPI Actual | `customfield_29307` | Epic |
| KPI Meta | `customfield_29308` | Epic |
| Dominios y Sub-dominios | `customfield_21200` | Epic |

---

## Flujo de estados — Experimentos

```
Created → DEFINING HYPOTESIS → EXPERIMENT PLANNING → READY TO RUN → RUNNING → Listo
                                                                            ↘ DISCARDED (Aborted)
```

### Transiciones y campos obligatorios

| Desde | Hacia | ID transición | Campos obligatorios |
|-------|-------|---------------|---------------------|
| Created | DEFINING HYPOTESIS | `11` | `customfield_57105` (Reviewer) |
| DEFINING HYPOTESIS | EXPERIMENT PLANNING | `21` | `customfield_57601`, `customfield_57401`, `customfield_57204`, `customfield_64501` |
| EXPERIMENT PLANNING | READY TO RUN | `41` | `customfield_57206`, `customfield_57207` |
| READY TO RUN | RUNNING | `71` | — |
| RUNNING | Listo | `101` | `customfield_18401`, `customfield_57403`, `customfield_62105`, `customfield_62106`, `customfield_68402`, `customfield_57404`, `customfield_57405` |
| Cualquier estado | DISCARDED | `111` | — |
| RUNNING | DISCARDED (Aborted) | `121` | — |

### Primary Metric — valores Insight (customfield_57601)

| Nombre | Clave |
|--------|-------|
| Conversion/Take Rate | `JIT-2509719` |
| Click | `JIT-2509718` |
| Otro | `JIT-2550661` |

Formato: `[{"key": "JIT-XXXXXXX"}]`

### Result conclusion — valores (customfield_18401)

| ID | Valor |
|----|-------|
| `75812` | Podemos afirmar que la intervención tuvo impacto. (H₀ rechazada) |
| `75813` | No podemos asegurar impacto con los datos disponibles. (No hay evidencia suficiente para rechazar H₀) |

Formato: `{"id": "75812"}`

---

## Sincronización desde EMA

Para sincronizar datos de EMA (experimentos A/B en `ema.appslatam.com`) a Jira:

```bash
python3 scripts/ema_sync.py https://ema.appslatam.com/experiments/<ID>
```

Sobreescribir ticket manualmente:
```bash
python3 scripts/ema_sync.py <URL_EMA> ESTRIV-9999
```

Requiere Chrome abierto con sesión de EMA activa. Si falla con "EMA devolvió HTML en vez de JSON", abrir Chrome y visitar ema.appslatam.com una vez.

---

## Recordatorio semanal eLoyalty (Google Chat)

Envía a Google Chat todos los experimentos abiertos de eLoyalty, ordenados por informador y días sin cambio de estado.

**Ejecución manual:**
```bash
python3 scripts/eloyalty_reminder.py
```

Credenciales en `scripts/.env`:
- `JIRA_TOKEN` — Personal Access Token de Jira
- `GOOGLE_CHAT_WEBHOOK` — URL del webhook del canal de Google Chat

---

## Otros scripts

**Detalle de experimentos EMA:**
```bash
python3 scripts/fetch_ema_detail.py <ID>
```

**Tabla consolidada de resultados:**
```bash
python3 scripts/fetch_results_table.py
```
