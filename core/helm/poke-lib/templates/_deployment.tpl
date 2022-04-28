{{- define "poke-lib.deployment.tpl" -}}
apiVersion: apps/v1
kind: Deployment
metadata:
  name: {{ include "poke-lib.fullname" . }}
  labels:
    {{- include "poke-lib.labels" . | nindent 4 }}
  {{- include "poke-lib.namespace" . | nindent 2 }}
spec:
  {{- if and (not .Values.autoscaling.enabled) .Values.replicaCount }}
  replicas: {{ .Values.replicaCount }}
  {{- end }}
  selector:
    matchLabels:
      {{- include "poke-lib.selectorLabels" . | nindent 6 }}
  template:
    metadata:
      {{- with .Values.podAnnotations }}
      annotations:
        {{- toYaml . | nindent 8 }}
      {{- end }}
      labels:
        {{- include "poke-lib.selectorLabels" . | nindent 8 }}
    spec:
      serviceAccountName: {{ include "poke-lib.serviceAccountName" . }}
      {{- with .Values.imagePullSecrets }}
      imagePullSecrets:
        {{- toYaml . | nindent 8 }}
      {{- end }}
      securityContext:
        {{- toYaml .Values.podSecurityContext | nindent 8 }}
      containers:
        - name: {{ .Chart.Name }}
          securityContext:
            {{- toYaml .Values.securityContext | nindent 12 }}
          image: "{{ .Values.image.repository }}:{{ .Values.image.tag | default .Chart.AppVersion }}"
          imagePullPolicy: {{ .Values.image.pullPolicy }}
          env:
            {{- include "poke-lib.containerEnv" . | nindent 12 }}
          ports:
            {{- include "poke-lib.containerPorts" . | indent 12 }}
          {{- include "poke-lib.containerProbes" . | indent 10 }}
          resources:
            {{- toYaml .Values.resources | nindent 12 }}
      {{- with .Values.nodeSelector }}
      nodeSelector:
        {{- toYaml . | nindent 8 }}
      {{- end }}
      {{- with .Values.affinity }}
      affinity:
        {{- toYaml . | nindent 8 }}
      {{- end }}
      {{- with .Values.tolerations }}
      tolerations:
        {{- toYaml . | nindent 8 }}
      {{- end }}
{{- end -}}
{{- define "poke-lib.deployment" -}}
{{- include "poke-lib.util.merge" (append . "poke-lib.deployment.tpl") -}}
{{- end -}}
