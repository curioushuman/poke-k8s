{{/*
Expand the name of the chart.
*/}}
{{- define "rbc-lib.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "rbc-lib.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "rbc-lib.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "rbc-lib.labels" -}}
helm.sh/chart: {{ include "rbc-lib.chart" . }}
{{ include "rbc-lib.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "rbc-lib.selectorLabels" -}}
app.kubernetes.io/name: {{ include "rbc-lib.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "rbc-lib.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "rbc-lib.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
Defined port, or default to 3000
*/}}
{{- define "rbc-lib.servicePort" -}}
{{- if .Values.service }}
{{- default 3000 .Values.service.port }}
{{- else }}
{{- 3000 }}
{{- end }}
{{- end }}

{{/*
Namespace
*/}}
{{- define "rbc-lib.namespace" -}}
{{- if .Values.global.namespaceOverride }}
namespace: {{ .Values.global.namespaceOverride }}
{{- end }}
{{- end }}
