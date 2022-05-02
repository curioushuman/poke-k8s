{{/*
Env vars consistent across containers
*/}}
{{- define "poke-lib.containerEnv" -}}
- name: POKE_SVC_PORT
  value: "{{ .Values.service.port }}"
- name: POKE_APP_NAME
  value: "{{ include "poke-lib.name" . }}"
- name: POKE_RELEASE_NAME
  value: "{{ .Release.Name }}"
- name: POKE_RELEASE_NAMESPACE
  value: "{{ .Release.Namespace }}"
{{- if .Values.global.umbrellaRelease }}
- name: POKE_UMBRELLA_RELEASE_NAME
  value: "{{ .Values.global.umbrellaRelease }}"
{{- end }}
{{- if .Values.mongodb }}
{{- if .Values.mongodb.service }}
- name: POKE_MONGODB_PORT
  {{- if .Values.mongodb.service.ports }}
  value: "{{ .Values.mongodb.service.ports.mongodb }}"
  {{- else }}
  value: "{{ .Values.mongodb.service.port }}"
  {{- end -}}
{{- end -}}
{{- if .Values.mongodb.auth }}
- name: POKE_MONGODB_DATABASE
  value: "{{ first .Values.mongodb.auth.databases }}"
{{- if .Values.mongodb.auth.enabled }}
- name: POKE_MONGODB_USERNAME
  value: "{{ first .Values.mongodb.auth.usernames }}"
- name: POKE_MONGODB_PASSWORD
  valueFrom:
    secretKeyRef:
      name: {{ .Values.mongodb.auth.existingSecret }}
      key: mongodb-passwords
{{- end -}}
{{- end -}}
{{- end }}
{{- $debug := default .Values.local.debug .Values.global.debug -}}
{{- if $debug }}
- name: POKE_DEBUG
  value: "true"
{{- end }}
{{- end }}

{{/*
Container ports
*/}}
{{- define "poke-lib.containerPorts" -}}
{{- if .Values.ports }}
{{- range .Values.ports }}
- name: {{ .name }}
  containerPort: {{ .port }}
  protocol: {{ .protocol }}
{{- end }}
{{- else }}
- name: {{ .Values.service.portName }}
  containerPort: {{ .Values.service.port }}
  protocol: {{ .Values.service.protocol }}
{{- end }}
{{- end }}

{{/*
Container probes
*/}}
{{- define "poke-lib.containerProbes" -}}
{{- if .Values.livenessProbe }}
livenessProbe:
{{- toYaml .Values.livenessProbe | nindent 2 }}
{{- end }}
{{- if .Values.startupProbe }}
startupProbe:
{{- toYaml .Values.startupProbe | nindent 2 }}
{{- end }}
{{- if .Values.readinessProbe }}
readinessProbe:
{{- toYaml .Values.readinessProbe | nindent 2 }}
{{- end }}
{{- end }}
