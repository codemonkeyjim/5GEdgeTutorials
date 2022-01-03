cat << EOF > deployment.yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: web-deployment
  labels:
    app: web
spec:
  replicas: 1
  selector:
    matchLabels:
      app: web
  template:
    metadata:
      labels:
        app: web
    spec:
      containers:
      - name: web
        image: public.ecr.aws/devrel-5gedge/demo-app
        ports:
        - containerPort: 80
      nodeSelector:
        failure-domain.beta.kubernetes.io/zone: "us-east-1-wl1-nyc-wlz-1"
---
apiVersion: v1
kind: Service
metadata:
  name: web-service
spec:
  type: NodePort
  selector:
    app: web
  ports:
    - port: 80
      targetPort: 80
      nodePort: 30007
      
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: web-deployment-2
  labels:
    app: web-2
spec:
  replicas: 1
  selector:
    matchLabels:
      app: web-2
  template:
    metadata:
      labels:
        app: web-2
    spec:
      containers:
      - name: web
        image: public.ecr.aws/devrel-5gedge/demo-app
        ports:
        - containerPort: 80
      nodeSelector:
        failure-domain.beta.kubernetes.io/zone: "us-east-1-wl1-bos-wlz-1"
---
apiVersion: v1
kind: Service
metadata:
  name: web-service-2
spec:
  type: NodePort
  selector:
    app: web-2
  ports:
    - port: 80
      targetPort: 80
      nodePort: 30008
EOF

kubectl apply -f deployment.yaml
