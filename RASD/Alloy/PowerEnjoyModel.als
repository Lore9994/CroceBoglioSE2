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
	expirationTime: one Date,
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
	numberOfPowerGrid: set PowerGrid,
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








pred show() {
	#User =0
	#Car =0
}

run show for 5
