# Stop service forwarding and remove old objects if any
pkill -f "kubectl port-forward"
nohup kubectl delete deployment blue green > /dev/null 2>&1
nohup kubectl delete service redis-service > /dev/null 2>&1

# Launch deployments and service defined in all.yaml
kubectl apply -f all.yaml > /dev/null 2>&1

echo "Objects created"
sleep 2

# Waiting for pods to start
echo "Waiting for pods to start..."
sleep 15

# Forward the service's port locally
nohup kubectl port-forward service/redis-service 6379:6379 > /dev/null 2>&1 &

# Check the version of Redis in the "blue" deployment
sleep 2
redis_version=$(redis-cli -p 6379 info | grep 'redis_version' | awk -F: '{print $2}')
echo "Current Redis version used is $redis_version"

# Stop forwarding the service's port
pkill -f "kubectl port-forward"

# Wait 5 seconds
sleep 5

# Change service selector to use version v2
kubectl patch service redis-service -p '{"spec":{"selector":{"version":"v2"}}}' > /dev/null 2>&1
echo "Modified service label to point to deployment with newer image"

# Forward the service's port again

nohup kubectl port-forward service/redis-service 6379:6379 > /dev/null 2>&1 &

# Check the version of Redis in the "green" deployment
sleep 2
redis_version=$(redis-cli -p 6379 info | grep 'redis_version' | awk -F: '{print $2}')
echo "Current Redis version used is $redis_version"

# Stop service forwarding and remove objects
pkill -f "kubectl port-forward"
nohup kubectl delete deployment blue green > /dev/null 2>&1
nohup kubectl delete service redis-service > /dev/null 2>&1