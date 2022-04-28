{{- define "rbc-lib.deployment.tpl" -}}
apiVersion: apps/v1
kind: Deployment
metadata:
  name: {{ include "rbc-lib.fullname" . }}
  labels:
    {{- include "rbc-lib.labels" . | nindent 4 }}
  {{- include "rbc-lib.namespace" . | nindent 2 }}
spec:
  {{- if and (not .Values.autoscaling.enabled) .Values.replicaCount }}
  replicas: {{ .Values.replicaCount }}
  {{- end }}
  selector:
    matchLabels:
      {{- include "rbc-lib.selectorLabels" . | nindent 6 }}
  template:
    metadata:
      {{- with .Values.podAnnotations }}
      annotations:
        {{- toYaml . | nindent 8 }}
      {{- end }}
      labels:
        {{- include "rbc-lib.selectorLabels" . | nindent 8 }}
    spec:
      serviceAccountName: {{ include "rbc-lib.serviceAccountName" . }}
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
            {{- include "rbc-lib.containerEnv" . | nindent 12 }}
          ports:
            {{- include "rbc-lib.containerPorts" . | indent 12 }}
          {{- include "rbc-lib.containerProbes" . | indent 10 }}
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
{{- define "rbc-lib.deployment" -}}
{{- include "rbc-lib.util.merge" (append . "rbc-lib.deployment.tpl") -}}
{{- end -}}
