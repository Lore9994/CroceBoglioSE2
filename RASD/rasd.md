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
Clients will interact with the system by a dedicated web service.  
The system will include all the basic functions of a car-sharing service plus some extra features.  
The service will allows registered client to search and reserve a car using GPS position or a specific address.  
The main purposes of the new system are:
- Be more efficient and reliable than the previous system.
- Offer a better service to the clients.


##### Actual system
Until now the electric-car company has a system where the client have to call a call-center and communicating his position, the operator searches, using the information system, for the nearest available car and propose it to the client, if the client accepts the car the operator reserves it for him.  
The cars are located in specific parking areas owned by the company, this areas are located in different areas of the city. In each parking area there are some electric power stations used for charging the cars and a small office for an operator who manage the parking and its cars (like: charge the car battery and set the car as available in the information system if it is ready for another ride).
When the client reach the indicated station, the operator check the reservation and verify the client identity, insert in the information system the data of the car rent and give the key of the car to the client.  
When client no needs more the car he have to bring it back in one of the specific parking areas, after this the office operator prepares the bill for the client and inserts all the data in the information system.
The cars maintenance is assigned to an external company.


##### Goals:
- Allows client to register to the system
- Allows user to login into the system
- Allows user to search cars in a specific zone
- Allows user to reserve a car from a list up to one hour
- Allows user to pick up and drive his reserved car
- User must be able to know in every moment the partial amount of the ride
- System must incentivize the virtuous behaviors of the users
