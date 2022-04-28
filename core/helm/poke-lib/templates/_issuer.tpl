{{- define "poke-lib.issuer.tpl" -}}
{{- $relName := include "poke-lib.name" . -}}
---
apiVersion: cert-manager.io/v1
kind: Issuer
metadata:
  name: letsencrypt-{{ $relName }}
  {{- include "poke-lib.namespace" . | nindent 2 }}
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
{{- define "poke-lib.issuer" -}}
{{- include "poke-lib.util.merge" (append . "poke-lib.issuer.tpl") -}}
{{- end -}}
