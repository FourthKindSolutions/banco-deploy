apiVersion: v1
kind: Service
metadata:
  labels:
    name: reverse-words
  name: reverse-words
spec:
  ports:
  - name: app
    port: 8080
    protocol: TCP
    targetPort: reverse-words
  selector:
    name: reverse-words
  sessionAffinity: None
  type: ClusterIP
