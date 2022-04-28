{{- define "poke-lib.service.tpl" -}}
apiVersion: v1
kind: Service
metadata:
  name: {{ include "poke-lib.fullname" . }}
  labels:
    {{- include "poke-lib.labels" . | nindent 4 }}
  {{- include "poke-lib.namespace" . | nindent 2 }}
spec:
  type: {{ .Values.service.type }}
  ports:
  {{- if .Values.ports }}
    {{- range .Values.ports }}
    - port: {{ .port }}
      targetPort: {{ .targetPort }}
      protocol: {{ .protocol }}
      name: {{ .name }}
    {{- end }}
  {{- else }}
    - port: {{ .Values.service.port }}
      targetPort: {{ .Values.service.targetPort }}
      protocol: {{ .Values.service.protocol }}
      name: {{ .Values.service.portName }}
  {{- end }}
  selector:
    {{- include "poke-lib.selectorLabels" . | nindent 4 }}
{{- end -}}
{{- define "poke-lib.service" -}}
{{- include "poke-lib.util.merge" (append . "poke-lib.service.tpl") -}}
{{- end -}}
