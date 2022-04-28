{{- define "rbc-lib.issuer.tpl" -}}
{{- $relName := include "rbc-lib.name" . -}}
---
apiVersion: cert-manager.io/v1
kind: Issuer
metadata:
  name: letsencrypt-{{ $relName }}
  {{- include "rbc-lib.namespace" . | nindent 2 }}
spec:
  acme:
    email: {{ default "mike@curioushuman.com.au" .Values.issuer.email }}
    server: {{ default "https://acme-v02.api.letsencrypt.org/directory" .Values.issuer.server }}
    privateKeySecretRef:
      name: letsencrypt-{{ $relName }}-secret
    solvers:
      # Use the HTTP-01 challenge provider
      - http01:
          ingress:
            class: nginx
{{- end -}}
{{- define "rbc-lib.issuer" -}}
{{- include "rbc-lib.util.merge" (append . "rbc-lib.issuer.tpl") -}}
{{- end -}}
