CREATE DEFINER=`root`@`localhost` PROCEDURE `getshipmentinfo`(in p_shipment_id INT)
BEGIN
Select s.shipment_id, s.origin, s.destination, s.shipment_date, s.status AS shipment_status, c.customer_id,
        c.name AS customer_name, c.phone, c.email, d.name as Driver_name, v.plate_number as Vehicle_number 
    FROM Logistics.Shipment s JOIN Logistics.Customer c ON s.customer_id = c.customer_id
    JOIN Logistics.Delivery del ON s.shipment_id = del.shipment_id
    JOIN Logistics.Driver d ON del.driver_id = d.driver_id
    JOIN Logistics.Vehicle v ON del.vehicle_id = v.vehicle_id
    WHERE s.shipment_id = p_shipment_id;
END