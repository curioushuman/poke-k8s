{{/*
Backend output
*/}}
{{- define "poke-lib.ingressBackEnd" -}}
service:
  name: {{ .serviceName }}
  port:
    number: {{ .servicePort }}
{{- end }}

{{/*
Backend, legacy output
*/}}
{{- define "poke-lib.ingressBackEndLegacy" -}}
serviceName: {{ .serviceName }}
servicePort: {{ .servicePort }}
{{- end }}

{{/*
Ingress class name
*/}}
{{- define "poke-lib.ingressClassName" -}}
{{- $className := "" }}
{{- if .Values.global.ingressClassName }}
{{- $className = .Values.global.ingressClassName }}
{{- end }}
{{- if .Values.ingress.className }}
{{- $className = .Values.ingress.className }}
{{- end }}
{{- if and $className (semverCompare ">=1.18-0" .Capabilities.KubeVersion.GitVersion) }}
ingressClassName: {{ $className }}
{{- end }}
{{- end }}