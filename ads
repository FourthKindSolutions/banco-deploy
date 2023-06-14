apiVersion: apps/v1
kind: Deployment
metadata:
  name: apache-proxy
spec:
  replicas: 1
  selector:
    matchLabels:
      app: apache-proxy
  template:
    metadata:
      labels:
        app: apache-proxy
    spec:
      containers:
        - name: apache-proxy
          image: httpd:2.4
          ports:
            - containerPort: 80
          volumeMounts:
            - name: config
              mountPath: /usr/local/apache2/conf/httpd.conf
              subPath: httpd.conf
          resources:
            limits:
              cpu: 500m
              memory: 512Mi
            requests:
              cpu: 100m
              memory: 256Mi
      volumes:
        - name: config
          configMap:
            name: apache-config
            items:
              - key: httpd.conf
                path: httpd.conf
---
apiVersion: v1
kind: ConfigMap
metadata:
  name: apache-config
data:
  httpd.conf: |
    ServerName localhost
    ProxyRequests Off
    <Proxy *>
      Order deny,allow
      Allow from all
    </Proxy>
    ProxyPass / http://10.50.57.155:3000/
    ProxyPassReverse / http://10.50.57.155:3000/
