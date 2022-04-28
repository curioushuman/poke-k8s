{{/*
Env vars consistent across containers
*/}}
{{- define "rbc-lib.containerEnv" -}}
- name: RBC_SVC_PORT
  value: "{{ .Values.service.port }}"
- name: RBC_APP_NAME
  value: "{{ include "rbc-lib.name" . }}"
- name: RBC_RELEASE_NAME
  value: "{{ .Release.Name }}"
- name: RBC_RELEASE_NAMESPACE
  value: "{{ .Release.Namespace }}"
{{- if .Values.global.umbrellaRelease }}
- name: RBC_UMBRELLA_RELEASE_NAME
  value: "{{ .Values.global.umbrellaRelease }}"
{{- end }}
{{- if .Values.mongodb }}
{{- if .Values.mongodb.service }}
- name: RBC_MONGODB_PORT
  value: "{{ .Values.mongodb.service.port }}"
{{- end -}}
{{- if .Values.mongodb.auth }}
- name: RBC_MONGODB_DATABASE
  value: "{{ first .Values.mongodb.auth.databases }}"
{{- if .Values.mongodb.auth.enabled }}
- name: RBC_MONGODB_USERNAME
  value: "{{ first .Values.mongodb.auth.usernames }}"
- name: RBC_MONGODB_PASSWORD
  valueFrom:
    secretKeyRef:
      name: {{ .Values.mongodb.auth.existingSecret }}
      key: mongodb-passwords
{{- end -}}
{{- end -}}
{{- end }}
{{- $debug := default .Values.local.debug .Values.global.debug -}}
{{- if $debug }}
- name: RBC_DEBUG
  value: "true"
{{- end }}
{{- end }}

{{/*
Container ports
*/}}
{{- define "rbc-lib.containerPorts" -}}
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
{{- define "rbc-lib.containerProbes" -}}
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
