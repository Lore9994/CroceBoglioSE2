![polimi-logo](Pictures/polimi-logo.png)
<center>  
  <h2>PowerEnjoy</h2>  
  <h3><b>R</b>equirements <b>A</b>nalysis and <b>S</b>pecifications <b>D</b>ocument</h3>
  <h6>Version 1.0<h6>
</center>
<br>

<h5>Software Engineering 2 (A.A. 2016/2017)</h5>
  - Simone Boglio (mat. 772263)  
  - Lorenzo Croce (mat. 807833)  

<div style="page-break-after: always;"></div>  

[comment]: <> (start second page)

##### Description of the given problem  
We will project and implement PowerEnjoy, a digital management system for a car-sharing service in the city of Milan, that exclusively employs electric cars and allow clients to use them.  
Clients will interact with the system by a dedicated web service or mobile app.  
The system will include all the basic functions of a car-sharing service plus some extra features.  
The service will allows registered client to search and reserve a car using GPS position or a specific address.  
The main purposes of the new system are:
- Offer a better service to the clients.
- Be more efficient and reliable than the previous system.


##### Actual system
Until now the electric-car company has a system where the client have to call a call-center and communicating his position, the operator searches, using the information system, for the nearest available car and propose it to the client, if the client accepts the car the operator reserves it for him.  
The cars are located in specific parking areas owned by the company, these areas are located in different zone of the city. In each parking area there are some electric power stations used for charging the cars and a small office for an operator who manage the parking and its cars (like: charge the car battery and set the car as available in the information system if it is ready for another ride).  
When the client reach the indicated station, the operator checks the reservation and verifies the client identity, inserts in the information system the data of the car rent and gives the key of the car to the client.  
When client no needs more the car he has to bring it back in one of the specific parking areas, after this the office operator prepares the bill for the client and inserts all the data in the information system.
The cars maintenance is assigned to an external company.


##### Goals:
- [G1] The client shall be able to access the service through web service.
- [G2] The client shall be able to search cars in a specific zone.
- [G3] The client shall be able to reserve a car from a list up to an hour.
- [G4] The client shall be able to picks up and drives the reserved car.
- [G5] The client shall be able to know where are the safe area for parking the car.
- [G6] The client shall be able to know the current charges during the ride.
- [G7] The client shall be able to end the ride when he leaves the car.
- [G8] The system must incentivize the virtuous behaviors of the users.
- [G9] The system has to offer public APIs to enable the possibility to develop additional services on top of the basic ones.
