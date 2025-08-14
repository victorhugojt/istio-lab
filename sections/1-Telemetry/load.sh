TIMES=2
for i in $(eval echo "{1..$TIMES}")
do  
    #     users times  
    siege -c 1 -r 20 http://192.168.49.2:30080/vehicle/City%20Truck
    siege -c 3 -r 5  http://192.168.49.2:30080/vehicle/Huddersfield%20Truck%20A
    siege -c 2 -r 5  http://192.168.49.2:30080/vehicle/Huddersfield%20Truck%20B
    siege -c 5 -r 3  http://192.168.49.2:30080/vehicle/London%20Riverside
    siege -c 2 -r 10 http://192.168.49.2:30080/vehicle/Village%20Truck
    sleep 3
done