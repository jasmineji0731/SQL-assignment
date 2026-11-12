PRAGMA foreign_keys = ON;

-- Question 1
SELECT SUM(quantityOnHand) AS containers_available
FROM item
WHERE itemDescription = 'bottle of antibiotics';

-- Question 2
SELECT volunteerName
FROM volunteer
WHERE volunteerTelephone IS NOT NULL
  AND volunteerTelephone NOT LIKE '2%'
  AND volunteerName NOT LIKE '% Jones'
ORDER BY volunteerName;

-- Question 3
SELECT DISTINCT v.volunteerName
FROM volunteer AS v
JOIN assignment AS a ON v.volunteerId = a.volunteerId
JOIN task AS t ON a.taskCode = t.taskCode
JOIN task_type AS tt ON t.taskTypeId = tt.taskTypeId
WHERE tt.taskTypeName = 'transporting'
ORDER BY v.volunteerName;

-- Question 4
SELECT t.taskDescription
FROM task AS t
LEFT JOIN assignment AS a ON t.taskCode = a.taskCode
WHERE a.taskCode IS NULL
ORDER BY t.taskDescription;

-- Question 5
SELECT DISTINCT pt.packageTypeName
FROM package_type AS pt
JOIN package AS p ON pt.packageTypeId = p.packageTypeId
JOIN package_contents AS pc ON p.packageId = pc.packageId
JOIN item AS i ON pc.itemId = i.itemId
WHERE LOWER(i.itemDescription) LIKE '%bottle%'
ORDER BY pt.packageTypeName;

-- Question 6
SELECT i.itemDescription
FROM item AS i
LEFT JOIN package_contents AS pc ON i.itemId = pc.itemId
WHERE pc.itemId IS NULL
ORDER BY i.itemDescription;

-- Question 7
SELECT DISTINCT t.taskDescription
FROM task AS t
JOIN assignment AS a ON t.taskCode = a.taskCode
JOIN volunteer AS v ON a.volunteerId = v.volunteerId
WHERE v.volunteerAddress LIKE '% NJ%'
ORDER BY t.taskDescription;

-- Question 8
SELECT DISTINCT v.volunteerName
FROM volunteer AS v
JOIN assignment AS a ON v.volunteerId = a.volunteerId
WHERE a.startDateTime >= '2021-01-01'
  AND a.startDateTime < '2021-07-01'
ORDER BY v.volunteerName;

-- Question 9
SELECT DISTINCT v.volunteerName
FROM volunteer AS v
JOIN assignment AS a ON v.volunteerId = a.volunteerId
JOIN package AS p ON a.taskCode = p.taskCode
JOIN package_contents AS pc ON p.packageId = pc.packageId
JOIN item AS i ON pc.itemId = i.itemId
WHERE LOWER(i.itemDescription) LIKE '%spam%'
ORDER BY v.volunteerName;

-- Question 10
SELECT i.itemDescription
FROM item AS i
JOIN package_contents AS pc ON i.itemId = pc.itemId
GROUP BY i.itemId, i.itemDescription, pc.packageId
HAVING SUM(i.itemValue * pc.itemQuantity) = 100
ORDER BY i.itemDescription;

-- Question 11
SELECT ts.taskStatusName AS taskStatus,
       COUNT(DISTINCT a.volunteerId) AS volunteerCount
FROM task_status AS ts
JOIN task AS t ON ts.taskStatusId = t.taskStatusId
JOIN assignment AS a ON t.taskCode = a.taskCode
GROUP BY ts.taskStatusId, ts.taskStatusName
ORDER BY volunteerCount DESC, taskStatus ASC;

-- Question 12
SELECT t.taskCode, SUM(p.packageWeight) AS totalPackageWeight
FROM task AS t
JOIN package AS p ON t.taskCode = p.taskCode
GROUP BY t.taskCode
ORDER BY totalPackageWeight DESC
LIMIT 1;

-- Question 13
SELECT COUNT(*) AS non_packing_task_count
FROM task AS t
JOIN task_type AS tt ON t.taskTypeId = tt.taskTypeId
WHERE tt.taskTypeName <> 'packing';

-- Question 14
SELECT i.itemDescription
FROM item AS i
JOIN package_contents AS pc ON i.itemId = pc.itemId
JOIN package AS p ON pc.packageId = p.packageId
JOIN assignment AS a ON p.taskCode = a.taskCode
GROUP BY i.itemId, i.itemDescription
HAVING COUNT(DISTINCT a.volunteerId) < 3
ORDER BY i.itemDescription;

-- Question 15
SELECT p.packageId,
       SUM(i.itemValue * pc.itemQuantity) AS packageValue
FROM package AS p
JOIN package_contents AS pc ON p.packageId = pc.packageId
JOIN item AS i ON pc.itemId = i.itemId
GROUP BY p.packageId
HAVING SUM(i.itemValue * pc.itemQuantity) > 100
ORDER BY packageValue ASC, p.packageId ASC;
