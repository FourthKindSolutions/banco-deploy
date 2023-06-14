apiVersion: apps/v1
kind: Deployment
metadata:
  name: nginx-proxy
spec:
  replicas: 1
  selector:
    matchLabels:
      app: nginx-proxy
  template:
    metadata:
      labels:
        app: nginx-proxy
    spec:
      containers:
        - name: nginx-proxy
          image: nginx
          ports:
            - containerPort: 80
          args:
            - /bin/sh
            - -c
            - |
              echo "server {
                listen       80;
                location / {
                  proxy_pass http://10.50.57.155:3000;
                }
              }" > /etc/nginx/conf.d/default.conf
          resources:
            limits:
              cpu: 500m
              memory: 512Mi
            requests:
              cpu: 100m
              memory: 256Mi
