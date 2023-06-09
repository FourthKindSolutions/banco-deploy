apiVersion: apps/v1
kind: Deployment
metadata:
  name: reverse-words
  labels:
    name: reverse-words
spec:
  replicas: 1
  selector:
    matchLabels:  
      name: reverse-words
  template:
    metadata:
      labels:
        name: reverse-words
    spec:
      containers:
        - name: reverse-words
          image: quay.io/mavazque/reversewords:latest 
          imagePullPolicy: Always
          ports:
            - name: reverse-words
              containerPort: 8080
              protocol: TCP
        - name: oauth-proxy 
          args:
            - -provider=openshift
            - -https-address=:8888
            - -http-address=
            - -email-domain=*
            - -upstream=http://localhost:8080
            - -tls-cert=/etc/tls/private/tls.crt
            - -tls-key=/etc/tls/private/tls.key
            - -cookie-secret-file=/etc/proxy/secrets/session_secret
            - -openshift-service-account=reversewords
            - -openshift-ca=/var/run/secrets/kubernetes.io/serviceaccount/ca.crt
            - -skip-auth-regex=^/metrics
          image: quay.io/openshift/origin-oauth-proxy:4.13
          imagePullPolicy: IfNotPresent
          ports:
            - name: oauth-proxy
              containerPort: 8888    
              protocol: TCP
          volumeMounts:
            - mountPath: /etc/tls/private
              name: secret-reversewords-tls
            - mountPath: /etc/proxy/secrets
              name: secret-reversewords-proxy
      serviceAccountName: reversewords
      volumes:
        - name: secret-reversewords-tls
          secret:
            defaultMode: 420
            secretName: reversewords-tls
        - name: secret-reversewords-proxy
          secret:
            defaultMode: 420
            secretName: reversewords-proxy
