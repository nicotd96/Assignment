CREATE DATABASE Logistics;

CREATE TABLE Logistics.Customer (
    customer_id INT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    phone VARCHAR(20) NOT NULL
);

CREATE TABLE Logistics.Shipment (
    shipment_id INT PRIMARY KEY,
    customer_id INT NOT NULL,
    origin VARCHAR(100) NOT NULL,
    destination VARCHAR(100) NOT NULL,
    shipment_date DATE DEFAULT (CURRENT_DATE),
    status VARCHAR(20) DEFAULT 'Pending',
    FOREIGN KEY (customer_id) REFERENCES Customer(customer_id)
);

CREATE TABLE Logistics.Warehouse (
    warehouse_id INT PRIMARY KEY,
    location VARCHAR(100) NOT NULL,
    capacity INT CHECK (capacity > 0)
);

CREATE TABLE Logistics.Shipment_Warehouse (
    shipment_id INT,
    warehouse_id INT,
    arrival_date DATE,
    departure_date DATE,
    PRIMARY KEY (shipment_id, warehouse_id),
    FOREIGN KEY (shipment_id) REFERENCES Shipment(shipment_id),
    FOREIGN KEY (warehouse_id) REFERENCES Warehouse(warehouse_id)
);

CREATE TABLE Logistics.Vehicle (
    vehicle_id INT PRIMARY KEY,
    plate_number VARCHAR(20) UNIQUE NOT NULL,
    capacity_weight DECIMAL(8,2) CHECK (capacity_weight > 0),
    status VARCHAR(20) DEFAULT 'Available'
);

CREATE TABLE Logistics.Driver (
    driver_id INT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    license_number VARCHAR(50) UNIQUE NOT NULL
);

CREATE TABLE Logistics.Delivery (
    delivery_id INT PRIMARY KEY,
    shipment_id INT NOT NULL,
    vehicle_id INT NOT NULL,
    driver_id INT NOT NULL,
    delivery_date DATE,
    status VARCHAR(20) DEFAULT 'Scheduled',
    FOREIGN KEY (shipment_id) REFERENCES Shipment(shipment_id),
    FOREIGN KEY (vehicle_id) REFERENCES Vehicle(vehicle_id),
    FOREIGN KEY (driver_id) REFERENCES Driver(driver_id)
);

CREATE TABLE Logistics.Payment (
    payment_id INT PRIMARY KEY,
    shipment_id INT NOT NULL,
    amount DECIMAL(10,2) CHECK (amount > 0),
    payment_date DATE DEFAULT (CURRENT_DATE),
    method VARCHAR(20) CHECK (method IN ('Cash', 'Card', 'Transfer')),
    FOREIGN KEY (shipment_id) REFERENCES Shipment(shipment_id)
);

CREATE TABLE Logistics.Shipment_Cost (
    cost_id INT PRIMARY KEY,
    shipment_id INT NOT NULL,
    customer_id INT NOT NULL,
    delivery_id INT NOT NULL,

    base_cost DECIMAL(10,2) CHECK (base_cost >= 0),
    fuel_cost DECIMAL(10,2) CHECK (fuel_cost >= 0),
    toll_cost DECIMAL(10,2) CHECK (toll_cost >= 0),
    insurance_cost DECIMAL(10,2) CHECK (insurance_cost >= 0),

    total_cost DECIMAL(10,2) GENERATED ALWAYS AS 
        (base_cost + fuel_cost + toll_cost + insurance_cost) STORED,

    cost_date DATE DEFAULT (CURRENT_DATE),

    FOREIGN KEY (shipment_id) REFERENCES Logistics.Shipment(shipment_id),
    FOREIGN KEY (customer_id) REFERENCES Logistics.Customer(customer_id),
    FOREIGN KEY (delivery_id) REFERENCES Logistics.Delivery(delivery_id)
);

INSERT INTO Logistics.Customer (customer_id, name, email, phone) VALUES
(1, 'ABC Traders', 'abc@traders.com', '9876543210'),
(2, 'Global Exports', 'global@exports.com', '9123456780'),
(3, 'FastMart', 'contact@fastmart.com', '9988776655'),
(4, 'Tech Supplies', 'sales@techsup.com', '9011223344'),
(5, 'HomeNeeds', 'support@homeneeds.com', '8899776655');

INSERT INTO Logistics.Shipment (shipment_id, customer_id, origin, destination, shipment_date, status) VALUES
(101, 1, 'Armenia', 'Cali', '2024-01-10', 'In Transit'),
(102, 2, 'Medellin', 'Bogota', '2024-01-11', 'Delivered'),
(103, 3, 'Manizalez', 'Popayan', '2024-01-12', 'Pending'),
(104, 4, 'Barranquilla', 'Armenia', '2024-01-13', 'In Transit'),
(105, 5, 'Bucaramanga', 'Pereira', '2024-01-14', 'Delivered'),
(106, 1, 'Armenia', 'Bogota', '2024-01-16', 'Pending'),
(107, 2, 'Cali', 'Medellin', '2024-01-17', 'In Transit'),
(108, 3, 'Pereira', 'Manizalez', '2024-01-18', 'Delivered'),
(109, 4, 'Bogota', 'Bucaramanga', '2024-01-19', 'In Transit'),
(110, 5, 'Popayan', 'Cali', '2024-01-20', 'Pending'),
(111, 1, 'Medellin', 'Armenia', '2024-01-21', 'Delivered'),
(112, 2, 'Barranquilla', 'Bogota', '2024-01-22', 'In Transit'),
(113, 3, 'Cali', 'Pereira', '2024-01-23', 'Pending'),
(114, 4, 'Manizalez', 'Bogota', '2024-01-24', 'Delivered'),
(115, 5, 'Armenia', 'Popayan', '2024-01-25', 'In Transit');

INSERT INTO Logistics.Warehouse (warehouse_id, location, capacity) VALUES
(301, 'Armenia Warehouse', 1000),
(302, 'Cali Warehouse', 1200),
(303, 'Medellin Warehouse', 900),
(304, 'Popayan Warehouse', 800),
(305, 'Bogota Warehouse', 1100);

INSERT INTO Logistics.Shipment_Warehouse (shipment_id, warehouse_id, arrival_date, departure_date) VALUES
(101, 301, '2024-01-10', '2024-01-11'),
(101, 302, '2024-01-12', NULL),
(102, 303, '2024-01-11', '2024-01-12'),
(103, 304, '2024-01-12', NULL),
(104, 305, '2024-01-13', NULL),
(106, 301, '2024-01-16', NULL),
(107, 302, '2024-01-17', NULL),
(108, 303, '2024-01-18', '2024-01-19'),
(109, 305, '2024-01-19', NULL),
(110, 304, '2024-01-20', NULL),
(111, 301, '2024-01-21', '2024-01-22'),
(112, 305, '2024-01-22', NULL),
(113, 302, '2024-01-23', NULL),
(114, 303, '2024-01-24', '2024-01-25'),
(115, 304, '2024-01-25', NULL);

INSERT INTO Logistics.Vehicle (vehicle_id, plate_number, capacity_weight, status) VALUES
(401, 'DL01AB1234', 5000, 'Available'),
(402, 'MH02CD5678', 7000, 'In Use'),
(403, 'KA03EF9012', 6000, 'Available'),
(404, 'TN04GH3456', 5500, 'In Use'),
(405, 'GJ05IJ7890', 6500, 'Available');

INSERT INTO Logistics.Driver (driver_id, name, license_number) VALUES
(501, 'Nicolas Taborda', '1094959282'),
(502, 'Jose Chang', '472832930'),
(503, 'Daniel Manrique', '74835231'),
(504, 'Mateo Bermudez', '253726232'),
(505, 'Jose Caro', '638284738');

INSERT INTO Logistics.Delivery (delivery_id, shipment_id, vehicle_id, driver_id, delivery_date, status) VALUES
(701, 101, 401, 501, '2024-01-11', 'Ongoing'),
(702, 102, 402, 502, '2024-01-12', 'Completed'),
(703, 103, 403, 503, '2024-01-13', 'Scheduled'),
(704, 104, 404, 504, '2024-01-14', 'Ongoing'),
(705, 105, 405, 505, '2024-01-15', 'Completed'),
(706, 106, 401, 501, '2024-01-17', 'Scheduled'),
(707, 107, 402, 502, '2024-01-18', 'Ongoing'),
(708, 108, 403, 503, '2024-01-19', 'Completed'),
(709, 109, 404, 504, '2024-01-20', 'Ongoing'),
(710, 110, 405, 505, '2024-01-21', 'Scheduled'),
(711, 111, 401, 501, '2024-01-22', 'Completed'),
(712, 112, 402, 502, '2024-01-23', 'Ongoing'),
(713, 113, 403, 503, '2024-01-24', 'Scheduled'),
(714, 114, 404, 504, '2024-01-25', 'Completed'),
(715, 115, 405, 505, '2024-01-26', 'Ongoing');

INSERT INTO Logistics.Payment (payment_id, shipment_id, amount, payment_date, method) VALUES
(801, 101, 1500.00, '2024-01-10', 'Card'),
(802, 102, 2000.00, '2024-01-11', 'Cash'),
(803, 103, 1800.00, '2024-01-12', 'Transfer'),
(804, 104, 2200.00, '2024-01-13', 'Card'),
(805, 105, 1700.00, '2024-01-14', 'Cash'),
(806, 106, 1600.00, '2024-01-16', 'Card'),
(807, 107, 2100.00, '2024-01-17', 'Cash'),
(808, 108, 1750.00, '2024-01-18', 'Transfer'),
(809, 109, 2300.00, '2024-01-19', 'Card'),
(810, 110, 1650.00, '2024-01-20', 'Cash'),
(811, 111, 1900.00, '2024-01-21', 'Transfer'),
(812, 112, 2250.00, '2024-01-22', 'Card'),
(813, 113, 1700.00, '2024-01-23', 'Cash'),
(814, 114, 2000.00, '2024-01-24', 'Transfer'),
(815, 115, 1850.00, '2024-01-25', 'Card');

INSERT INTO Logistics.Shipment_Cost (cost_id, shipment_id, customer_id, delivery_id,
 base_cost, fuel_cost, toll_cost, insurance_cost, cost_date) VALUES
(901, 101, 1, 701, 271.00, 440.00, 274.00, 56.25, '2024-01-10'),
(902, 102, 2, 702, 350.00, 589.00, 382.00, 75.00, '2024-01-11'),
(903, 103, 3, 703, 390.00, 515.00, 331.00, 67.50, '2024-01-12'),
(904, 104, 4, 704, 442.00, 626.00, 415.00, 82.50, '2024-01-13'),
(905, 105, 5, 705, 317.00, 492.00, 328.00, 63.75, '2024-01-14'),
(906, 106, 1, 706, 333.00, 474.00, 304.00, 60.00, '2024-01-16'),
(907, 107, 2, 707, 450.00, 672.00, 427.00, 78.75, '2024-01-17'),
(908, 108, 3, 708, 354.00, 588.00, 323.00, 65.62, '2024-01-18'),
(909, 109, 4, 709, 436.00, 694.00, 447.00, 86.25, '2024-01-19'),
(910, 110, 5, 710, 315.00, 509.00, 312.00, 61.87, '2024-01-20'),
(911, 111, 1, 711, 350.00, 538.00, 373.00, 71.25, '2024-01-21'),
(912, 112, 2, 712, 432.00, 675.00, 431.00, 84.37, '2024-01-22'),
(913, 113, 3, 713, 328.00, 525.00, 309.00, 63.75, '2024-01-23'),
(914, 114, 4, 714, 390.00, 574.00, 400.00, 75.00, '2024-01-24'),
(915, 115, 5, 715, 389.00, 555.00, 322.00, 69.37, '2024-01-25');

#view 1: Delivery Status report
SELECT c.name AS Customer_Name, s.origin, s.destination, d.status
FROM Logistics.Customer c
JOIN Logistics.Shipment s ON c.customer_id = s.customer_id
JOIN Logistics.Delivery d ON s.shipment_id = d.shipment_id;

#view 2: Type of transation Summery
SELECT method AS payment_method, SUM(amount) AS total_amount
FROM Logistics.Payment
GROUP BY method;

#view 3: Cost Vs Billing, margin %
SELECT 
    s.shipment_id,
    c.name AS customer_name,
    s.origin,
    s.destination,
    d.status AS delivery_status,
    p.amount AS billed_amount,
    sc.total_cost,
    (p.amount - sc.total_cost) AS profit_amount,
    ROUND(((p.amount - sc.total_cost) / p.amount) * 100, 2) AS profit_margin_percentage
FROM Logistics.Shipment s
JOIN Logistics.Customer c ON s.customer_id = c.customer_id
JOIN Logistics.Payment p ON s.shipment_id = p.shipment_id
JOIN Logistics.Shipment_Cost sc ON s.shipment_id = sc.shipment_id
JOIN Logistics.Delivery d ON s.shipment_id = d.shipment_id
HAVING ROUND(((p.amount - sc.total_cost) / p.amount) * 100, 2) < 25;

#view 4: Profit by customer
SELECT 
    c.name AS customer_name,
    SUM(p.amount) AS total_billed,
    SUM(sc.total_cost) AS total_cost,
    SUM(p.amount - sc.total_cost) AS total_profit
FROM Logistics.Payment p
JOIN Logistics.Shipment s ON p.shipment_id = s.shipment_id
JOIN Logistics.Shipment_Cost sc ON s.shipment_id = sc.shipment_id
JOIN Logistics.Customer c ON s.customer_id = c.customer_id
GROUP BY c.name;

#view 5: profit margin tag
SELECT 
    s.shipment_id,
    p.amount AS billed_amount,
    sc.total_cost,
    (p.amount - sc.total_cost) AS profit,
    CASE
        WHEN (p.amount - sc.total_cost) > 500 THEN 'High profit'
        WHEN (p.amount - sc.total_cost) BETWEEN 0 AND 500 THEN 'Low profit'
        ELSE 'Loss'
    END AS profit_category
FROM Logistics.Shipment s
JOIN Logistics.Payment p ON s.shipment_id = p.shipment_id
JOIN Logistics.Shipment_Cost sc ON s.shipment_id = sc.shipment_id;

#view 6: Cost moving AVG 
SELECT 
    customer_id,
    shipment_id,
    cost_date,
    (base_cost + fuel_cost + toll_cost + insurance_cost) AS total_cost,
    AVG(base_cost + fuel_cost + toll_cost + insurance_cost) OVER (
        PARTITION BY customer_id 
        ORDER BY cost_date
        ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
    ) AS Moving_AVG_cost
FROM Logistics.Shipment_Cost;


