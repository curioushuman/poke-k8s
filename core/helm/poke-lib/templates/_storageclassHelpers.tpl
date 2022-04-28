{{/*
Storage class name
*/}}
{{- define "poke-lib.storageClassName" -}}
{{- if .Values.storageClass.create }}
{{- default (include "poke-lib.fullname" .) .Values.storageClass.name }}
{{- else }}
{{- default "default" .Values.storageClass.name }}
{{- end }}
{{- end }}

{{/*
Return the appropriate apiVersion for the storage class
*/}}
{{- define "poke-lib.storageClassApiVersion" -}}
{{- default "storage.k8s.io/v1" .Values.storageClass.apiVersion -}}
{{- end }}

{{/*
Provisioner
*/}}
{{- define "poke-lib.storageClassProvisioner" -}}
{{- default "kubernetes.io/no-provisioner" .Values.storageClass.provisioner }}
{{- end }}

{{/*
Volume expansion policy
*/}}
{{- define "poke-lib.storageClassVolumeExpansion" -}}
{{- default "false" .Values.storageClass.allowVolumeExpansion }}
{{- end }}

{{/*
Volume binding mode
*/}}
{{- define "poke-lib.storageClassVolumeBinding" -}}
{{- default "WaitForFirstConsumer" .Values.storageClass.volumeBindingMode }}
{{- end }}

{{/*
Reclaim policy
*/}}
{{- define "poke-lib.storageClassReclaimPolicy" -}}
{{- default "Retain" .Values.storageClass.reclaimPolicy }}
{{- end }}
