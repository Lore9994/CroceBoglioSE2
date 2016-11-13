//Alloy model for PowerEnjoy  system

//Defines Bool -> True, False
open util/boolean

sig Stringa {}

sig Date{
	time: one Int
}
{
	time >0
}

sig Position {
	positionId: one Int
}
{
	positionId > 0
}

abstract sig User {}

sig UnregisteredUser extends User {}

sig RegisteredUser extends User {
	userId: one Int,
	username: one Stringa,
	email: one Stringa,
	password: one Stringa,
	name: one Stringa,
	surname: one Stringa,
	phoneNumber: lone Stringa,
	creditcardNumber: one Stringa
}
{
	userId>0
}

abstract sig StateCar {}
one sig AvailableCar extends StateCar{}
one sig UnavailableCar extends StateCar{}
one sig InUseCar extends StateCar{}
one sig ReservedCar extends StateCar{}

abstract sig StateBattery{}
one sig LowBattery extends StateBattery{}
one sig MediumBattery extends StateBattery{}
one sig HighBattery extends StateBattery{}

sig Car {
	carId: one Int,
	batteryLvl: one StateBattery,
	stateAvailability: one StateCar,
	licensePlate: one Stringa,
	doorState: one Bool, // False = locked door, True = unlocked door
	engineState: one Bool, // False = engine off, True = engingeOn
	numberOfSeats: one Int,
	position: one Area,	
	batteryInCharge: one Bool,
	displayInformation: one Bool //current charge, map, battery level
}
{
	(batteryInCharge = True) => (engineState = False)
	(displayInformation = True) => (stateAvailability = InUseCar)
	(stateAvailability = UnavailableCar) => (engineState = False) 
	(stateAvailability = AvailableCar) => (engineState = False and position = SafeArea)
	(stateAvailability = ReservedCar) => (engineState = False and position = SafeArea) 
	(stateAvailability = InUseCar) <=> (doorState = True)
	(engineState = True) => (stateAvailability = InUseCar)
	(doorState = True) => (stateAvailability = InUseCar)
	carId > 0
	numberOfSeats = 4
}

sig Reservation {
	reservationId: one Int,
	reservationTime: one Date,
	reservedCar: one Car,
	expired: one Bool,
	user: one RegisteredUser,
	fee: one Bool
}
{
	(fee = True) => (expired = True)
	reservationId >0
}

abstract sig Area {
	position: one Position
}
sig NoSafeArea extends Area{}
sig SafeArea extends Area {}
sig SpecialArea extends SafeArea{
	numberOfPowerGrid: Int, 
	car: set Car,
}
{
car.position = SpecialArea
}

abstract sig StateRide {}
one sig ActiveRide extends StateRide{}
one sig EndedRide extends StateRide{}

sig Ride{
	rideId: one Int,
	reservation: one Reservation,
	state: one StateRide,
	startTime: one Date,
	endTime: lone Date,
	startPosition: one SafeArea,
	endPosition: lone SafeArea,
	batteryStart: one StateBattery,
	batteryEnd: lone StateBattery,
	passengersNumber: Int,
	cost: one Int,
	bonusSet: set Bonus,
	specialAreaTooFar: lone Bool,
	batteryInCharge: lone Bool
}
{
	rideId > 0
	cost >= 0
	passengersNumber >= 0 
	passengersNumber < reservation.reservedCar.numberOfSeats //< because 1 is the user
	startTime.time >= reservation.reservationTime.time
	startTime.time < endTime.time
	specialAreaTooFar = True <=> (endPosition != SpecialArea and batteryInCharge = False)
	batteryInCharge = True => endPosition = SpecialArea
	state = ActiveRide <=> (no endPosition) and (no batteryInCharge) and (no specialAreaTooFar)
	state = EndedRide <=> (one endPosition) and (one batteryInCharge) and (one specialAreaTooFar)
	(BonusInCharge in bonusSet) <=> (BonusDistanceLowBattery not in bonusSet)
	(BonusHighBattery in bonusSet) <=> (BonusDistanceLowBattery not in bonusSet)
	state = ActiveRide => (no bonusSet)
}

abstract sig Bonus {}
one sig BonusPassenger extends Bonus{}
one sig BonusHighBattery extends Bonus{}
one sig BonusInCharge extends Bonus{}
one sig BonusDistanceLowBattery extends Bonus{}

//////////Facts 

fact registeredUserAreUnique{
	all u1, u2: RegisteredUser | (u1 != u2) => (u1.userId != u2.userId)
	all u1, u2: RegisteredUser | (u1 != u2) => (u1.email != u2.email)	
}

fact carAreUnique{
	all c1, c2: Car | (c1 != c2) => (c1.carId != c2.carId)
	all c1, c2: Car | (c1 != c2) => (c1.licensePlate != c2.licensePlate)
}

fact positionAreUnique{
	all a1, a2: Area | ((a1 != a2) <=> (a1.position.positionId != a2.position.positionId))
}

fact stateRide{
	all r1: Ride | (r1.state = ActiveRide) => (one r1.startTime and one r1.startPosition and one r1.reservation)
	all r1: Ride | (r1.state = EndedRide) => (one r1.startTime and one r1.startPosition and one r1.reservation and one r1.endTime and one r1.endPosition)
}

fact noTwoConcurrentReservationSameUser{
	no r1, r2: Reservation | (r1 != r2 and r1.user = r2. user and (r1.expired = False and r2.expired = False))
}

fact noReservationIfUserIsDriving{
	no r1: Reservation, rd1: Ride | (r1 != rd1.reservation and r1.user = rd1.reservation.user and rd1.state = ActiveRide)
}

fact noTwoConcurrentReservationSameCar{
	no r1, r2: Reservation | (r1 != r2 and r1.reservedCar = r2. reservedCar and (r1.expired = False and r2.expired = False))
}

fact unavailableCarCannotBeReserved{
	no c1: Car, r1: Reservation | (r1.reservedCar = c1 and c1.stateAvailability = UnavailableCar)
}

fact reservedCard{
	all c1: Car, r1: Reservation | (r1.reservedCar = c1 and r1.expired = False) <=> (c1.stateAvailability = ReservedCar)
}

fact expiredReservation{
	all r1: Reservation, rd1: Ride | (r1 = rd1.reservation) => (r1.expired = True)
	all r1: Reservation | (r1.fee = True) => (r1.expired = True and r1.reservedCar.stateAvailability = AvailableCar)
}

fact inUseCar{
	all rd1: Ride | (rd1.state = ActiveRide) <=> (rd1.reservation.reservedCar.stateAvailability = InUseCar)
	all c1: Car | (c1.position != SafeArea) => (c1.stateAvailability = InUseCar and c1.position = NoSafeArea)
}

fact inUseCarCannotBeReserved{
	no r1: Reservation,  rd1: Ride | (r1 != rd1.reservation and r1.reservedCar = rd1.reservation.reservedCar and rd1.state = ActiveRide and r1.expired = False)
}

fact noTwoConcurrentRideSameReservation{
	no rd1, rd2: Ride | (rd1 != rd2 and rd1.reservation = rd2.reservation)
}

fact noTwoConcurrentRideSameCar{
	no rd1, rd2: Ride | (rd1 != rd2 and rd1.state = ActiveRide and rd2.state = ActiveRide and rd1.reservation.reservedCar = rd2.reservation.reservedCar)
}

fact fee{
	all r1: Reservation | (r1.fee = True) => (no rd1: Ride | rd1.reservation = r1)
}

fact safeAreaForEnededRide{
	all rd1: Ride | (rd1.state = EndedRide) <=> (rd1.endPosition = SafeArea)
}

fact specialArea{
	all rd1: Ride | (rd1.state = EndedRide and rd1.batteryInCharge = True) => (rd1.endPosition = SpecialArea)
	all c1: Car | (c1.batteryInCharge = True) => (c1.position = SpecialArea)
	all sp: SpecialArea | (sp.numberOfPowerGrid <= #{ c1: Car | (c1.batteryInCharge = True and c1.position = sp)})
}

fact bonusPassenger{
	all rd1: Ride | (rd1.state = EndedRide and rd1.passengersNumber>=1) <=> (one b: BonusPassenger | b in rd1.bonusSet)
}

fact bonusHighBattery{
	all rd1: Ride | (rd1.state = EndedRide and rd1.batteryEnd = HighBattery) <=> (one b: BonusHighBattery | b in rd1.bonusSet)
}

fact bonusInCharge{
	all rd1: Ride | (rd1.state = EndedRide and rd1.batteryInCharge = True ) <=> (one b: BonusInCharge | b in rd1.bonusSet)
}

fact bonusLowbatteryDistance{
	all rd1: Ride | (rd1.state = EndedRide and (rd1.specialAreaTooFar = True or rd1.batteryEnd = LowBattery)) <=> (one b: BonusDistanceLowBattery | b in rd1.bonusSet)
}

fact availableCarInSafeArea{
	all c1: Car | (c1.stateAvailability = AvailableCar) <=> (c1.position = SafeArea and (one sa: SafeArea | c1 in sa.car))
}

fact availableAndReservedCarInSpecialAreaAreInSpecialAreaSet{
	all c1: Car, sa: SpecialArea | (((c1.position = sa) and (c1.stateAvailability = AvailableCar or c1.stateAvailability = ReservedCar)) => (c1 in sa.car) )
}

//////////Asserts

assert noPassengersNumberExceedSeats{
	no rd1: Ride | (#rd1.passengersNumber > rd1.reservation.reservedCar.numberOfSeats)
}

assert carCondition{
	no c1: Car | (c1.engineState = True and c1.stateAvailability != InUseCar)
	no c1: Car | (c1.doorState = True and c1.stateAvailability != InUseCar)
	no c1: Car | (c1.batteryInCharge = True and c1.position != SpecialArea)
	no c1: Car | (c1.batteryInCharge = True and c1.engineState = True)
}

assert rideCondition{
	no r1: Ride | (r1.specialAreaTooFar = True and r1.endPosition = SpecialArea)
	no r1: Ride | (r1.batteryInCharge = True and r1.endPosition != SpecialArea)
	no r1: Ride | (r1.state = ActiveRide and (some r1.bonusSet or one r1.endPosition))
	no r1: Ride | (r1.state = EndedRide and (no r1.endPosition))
	no r1: Ride | ((BonusInCharge in r1.bonusSet) and (BonusDistanceLowBattery in r1.bonusSet))
	no r1: Ride | ((BonusHighBattery in r1.bonusSet) and (BonusDistanceLowBattery in r1.bonusSet))
}

assert bonusInChargeSpecialArea{
	all r1: Ride | (r1.endPosition = SpecialArea and r1.batteryInCharge = True => (BonusInCharge in r1.bonusSet))
	all r1: Ride | (r1.endPosition = SpecialArea and r1.batteryInCharge = False => not(BonusInCharge in r1.bonusSet))
}

assert carAvailableAreAlwaysInSafeArea{
	all c1: Car | (c1.stateAvailability = AvailableCar) => (c1.position = SafeArea)
}
assert carReservedAreAlwaysInSafeArea{
	all c1: Car | (c1.stateAvailability = ReservedCar) => (c1.position = SafeArea)
}

assert noRideWithoutReservation{
	all rd1: Ride | (one r1: Reservation | rd1.reservation = r1)
}

pred show() {
	#{c1: Car |c1.batteryInCharge = True} >=1
	#{c1: Car |c1.batteryInCharge = False} >=1
	#{c1: Car |c1.position = NoSafeArea} >=1
	#Ride = 1
	#User =2
	#Reservation = 2
}

check rideCondition
check carCondition
check bonusInChargeSpecialArea
check noPassengersNumberExceedSeats
check carReservedAreAlwaysInSafeArea
check carAvailableAreAlwaysInSafeArea
check noRideWithoutReservation

run show for 4
