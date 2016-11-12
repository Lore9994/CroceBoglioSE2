// Alloy model for PowerEnjoy  system

//Defines Bool -> True, False
open util/boolean

sig Stringa {}
sig Date{}
sig Position {
	positionId: one Int
}
sig PowerGrid{}


abstract sig User {}

sig UnregisteredUser extends User {
}

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
sig AvailableCar extends StateCar{}
sig UnavailableCar extends StateCar{}
sig InUseCar extends StateCar{}
sig ReservedCar extends StateCar{}

abstract sig StateBattery{}
sig LowBattery extends StateBattery{}
sig MediumBattery extends StateBattery{}
sig HighBattery extends StateBattery{}

sig Car {
	carId: one Int,
	batteryLvl: one StateBattery,
	stateAvailability: one StateCar,
	licensePlate: one Stringa,
	doorState: one Bool,
	engineState: one Bool,
	numberOfSeats: one Int,
	position: one Area,	
	batteryInCharge : one Bool,
	screen: one CarScreen
}
{
	carId > 0
	numberOfSeats = 4
}

sig CarScreen {
	displayBatteryLvl: Bool,
	displayCurrentCharge: Bool,
	displayMapCurrentPosition: Bool
}

sig Reservation {
	reservationId: one Int,
	reservedCar: one Car,
	expired: one Bool,
	user: one RegisteredUser
}
{
	reservationId >0
}

sig Area {
	position: one Position
}
sig NoSafeArea extends Area{}
sig SafeArea extends Area {}
sig SpecialArea extends SafeArea{
	numberOfPowerGrid: some PowerGrid,
	carInCharge: set Car 
}

sig Ride{
	rideId: one Int,
	reservation: one Reservation,
	startTime: one Date,
	endTime: one Date,
	startPosition: one SafeArea,
	endPosition: one SafeArea,
	cost: one Int,
	bonusSet: set Bonus,
	passengersNumber: Int,
}
{
	rideId>0
	cost>0
	passengersNumber>=0
}

abstract sig Bonus {}
sig BonusPassenger extends Bonus{}
sig BonusHighBattery extends Bonus{}
sig BonusInCharge extends Bonus{}
sig BonusDistance extends Bonus{}
sig BonusLowBattery extends Bonus{}

fact registeredUserAreUnique{
	all u1, u2: RegisteredUser | (u1 != u2) => (u1.userId != u2.userId)
	all u1, u2: RegisteredUser | (u1 != u2) => (u1.email != u2.email)	
}

fact carAreUnique{
	all c1, c2: Car | (c1 != c2) => (c1.carId != c2.carId)
	all c1, c2: Car | (c1 != c2) => (c1.licensePlate != c2.licensePlate)
	all c1, c2: Car | (c1 != c2) => (c1.screen != c2.screen)
}

fact reseravationAreUnique{
	all r1, r2: Reservation | (r1 != r2) => (r1.reservationId != r2.reservationId)
}

fact userCanMadeOneReservationAtTime{
	all r1, r2: Reservation | (r1 != r2 && r1.user = r2.user) => (r1.expired = True or r2.expired = True)
	all r1, r2: Reservation | (r1 != r2 && r1.Car = r2.Car) => (r1.expired = True or r2.expired = True)
	all r: Reservation |((r.expired = False) => r.Car.stateAvailability = ReservedCar) && (r.expired = True) => r.Car.stateAvailability = AvailableCar)
}





pred show() {
	#User =0
	#Car =0
}

run show for 5
