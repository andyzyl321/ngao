{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "app.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "app.fullname" -}}
{{- if .Values.fullnameOverride -}}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- $name := default .Chart.Name .Values.nameOverride -}}
{{- if contains $name .Release.Name -}}
{{- .Release.Name | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}
{{- end -}}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "app.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Shorthand for component names
*/}}

{{- define "app.mysql.name" -}}
{{- .Release.Name -}}-mysql
{{- end -}}
{{- define "app.web.name" -}}
{{- include "app.fullname" . -}}-web
{{- end -}}
{{- define "app.rails-env.name" -}}
{{- include "app.fullname" . -}}-rails-env
{{- end -}}
{{- define "app.delayed-job.name" -}}
{{- include "app.fullname" . -}}-delayed-job
{{- end -}}
{{- define "app.setup.name" -}}
{{- include "app.fullname" . -}}-setup
{{- end -}}
{{- define "app.solr.name" -}}
{{- .Release.Name -}}-solr-svc
{{- end -}}
{{- define "app.zookeeper.name" -}}
{{- .Release.Name -}}-zookeeper
{{- end -}}