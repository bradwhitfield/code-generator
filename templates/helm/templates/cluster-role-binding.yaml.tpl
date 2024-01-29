{{ "{{ if eq .Values.installScope \"cluster\" }}" }}
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRoleBinding
metadata:
  name: {{ "{{ include \"app.fullname\" . }}" }}
roleRef:
  kind: ClusterRole
  apiGroup: rbac.authorization.k8s.io
  name: ack-{{ .ServicePackageName }}-controller
subjects:
- kind: ServiceAccount
  name: {{ "{{ include \"service-account.name\" . }}" }}
  namespace: {{ "{{ .Release.Namespace }}" }}
{{ "{{ else if .Values.watchNamespace }}" }}
{{ "{{ $namespaces := split \",\" .Values.watchNamespace }}" }}
{{ "{{ $fullname := include \"app.fullname\" .  }}" }}
{{ "{{ $releaseNamespace := .Release.Namespace }}" }}
{{ "{{ $serviceAccountName := include \"service-account.name\" .  }}" }}
{{ "{{ range $namespaces }}" }}
---
apiVersion: rbac.authorization.k8s.io/v1
kind: RoleBinding
metadata:
  name: {{ "{{ $fullname }}" }}
  namespace: {{ "{{ . }}" }}
roleRef:
  kind: Role
  apiGroup: rbac.authorization.k8s.io
  name: ack-{{ .ServicePackageName }}-controller
subjects:
- kind: ServiceAccount
  name: {{ "{{ $serviceAccountName }}" }}
  namespace: {{ "{{ $releaseNamespace }}" }}
{{ "{{ end }}" }}
{{ "{{ end }}" }}