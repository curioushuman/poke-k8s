{{/*
Storage class name
*/}}
{{- define "rbc-lib.storageClassName" -}}
{{- if .Values.storageClass.create }}
{{- default (include "rbc-lib.fullname" .) .Values.storageClass.name }}
{{- else }}
{{- default "default" .Values.storageClass.name }}
{{- end }}
{{- end }}

{{/*
Return the appropriate apiVersion for the storage class
*/}}
{{- define "rbc-lib.storageClassApiVersion" -}}
{{- default "storage.k8s.io/v1" .Values.storageClass.apiVersion -}}
{{- end }}

{{/*
Provisioner
*/}}
{{- define "rbc-lib.storageClassProvisioner" -}}
{{- default "kubernetes.io/no-provisioner" .Values.storageClass.provisioner }}
{{- end }}

{{/*
Volume expansion policy
*/}}
{{- define "rbc-lib.storageClassVolumeExpansion" -}}
{{- default "false" .Values.storageClass.allowVolumeExpansion }}
{{- end }}

{{/*
Volume binding mode
*/}}
{{- define "rbc-lib.storageClassVolumeBinding" -}}
{{- default "WaitForFirstConsumer" .Values.storageClass.volumeBindingMode }}
{{- end }}

{{/*
Reclaim policy
*/}}
{{- define "rbc-lib.storageClassReclaimPolicy" -}}
{{- default "Retain" .Values.storageClass.reclaimPolicy }}
{{- end }}
