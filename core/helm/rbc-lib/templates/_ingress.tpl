{{- define "rbc-lib.ingress.tpl" -}}
{{- $fullName := include "rbc-lib.fullname" . -}}
{{- $svcPort := include "rbc-lib.servicePort" . -}}
{{- if and .Values.ingress.className (not (semverCompare ">=1.18-0" .Capabilities.KubeVersion.GitVersion)) }}
  {{- if not (hasKey .Values.ingress.annotations "kubernetes.io/ingress.class") }}
  {{- $_ := set .Values.ingress.annotations "kubernetes.io/ingress.class" .Values.ingress.className}}
  {{- end }}
{{- end }}
{{- if semverCompare ">=1.19-0" .Capabilities.KubeVersion.GitVersion -}}
apiVersion: networking.k8s.io/v1
{{- else if semverCompare ">=1.14-0" .Capabilities.KubeVersion.GitVersion -}}
apiVersion: networking.k8s.io/v1beta1
{{- else -}}
apiVersion: extensions/v1beta1
{{- end }}
kind: Ingress
metadata:
  name: {{ $fullName }}
  labels:
    {{- include "rbc-lib.labels" . | nindent 4 }}
  {{- with .Values.ingress.annotations }}
  annotations:
    {{- toYaml . | nindent 4 }}
  {{- end }}
  {{- include "rbc-lib.namespace" . | nindent 2 }}
spec:
  {{- include "rbc-lib.ingressClassName" . | nindent 2 }}
  {{- if .Values.ingress.tls }}
  tls:
  {{- range .Values.ingress.tls }}
  - hosts:
      {{- range .hosts }}
      - {{ . | quote }}
      {{- end }}
    secretName: {{ .secretName }}
  {{- end }}
  {{- end }}
  rules: {{- range .Values.ingress.hosts }}
  - host: {{ .host | quote }}
    http:
      paths:
        {{- range .paths }}
        - pathType: {{ .pathType }}
          path: {{ .path }}
          {{- if and .pathType (semverCompare ">=1.18-0" $.Capabilities.KubeVersion.GitVersion) }}

          {{- end }}
          backend:
            {{- $svcBackend := (dict "serviceName" $fullName "servicePort" $svcPort) }}
            {{- if .backend }}
            {{- $svcBackend = .backend }}
            {{- end }}
            {{- if semverCompare ">=1.19-0" $.Capabilities.KubeVersion.GitVersion }}
            {{- include "rbc-lib.ingressBackEnd" $svcBackend | nindent 14 }}
            {{- else }}
            {{- include "rbc-lib.ingressBackEndLegacy" $svcBackend | indent 14 }}
            {{- end }}
        {{- end }}
  {{- end }}
{{- end -}}
{{- define "rbc-lib.ingress" -}}
{{- include "rbc-lib.util.merge" (append . "rbc-lib.ingress.tpl") -}}
{{- end -}}
