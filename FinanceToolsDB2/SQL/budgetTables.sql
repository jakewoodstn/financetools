CREATE TABLE budgetType (
  budgetTypeId INT IDENTITY (1, 1) PRIMARY KEY,
  budgetTypeName VARCHAR(255) NOT NULL UNIQUE,
  created_at DATETIME NOT NULL DEFAULT GETDATE(),
  created_by VARCHAR(255) NOT NULL DEFAULT SUSER_SNAME(),
  updated_at DATETIME,
  updated_by VARCHAR(255)
)

CREATE TABLE budgetMaster (
  budgetMasterId INT IDENTITY (1, 1) PRIMARY KEY,
  budgetTypeId INT NOT NULL,
  budgetReferenceId INT NOT NULL,
  created_at DATETIME NOT NULL DEFAULT GETDATE(),
  created_by VARCHAR(255) NOT NULL DEFAULT SUSER_SNAME(),
  updated_at DATETIME,
  updated_by VARCHAR(255),
  CONSTRAINT fk_bmast_btype FOREIGN KEY (budgetTypeId) REFERENCES budgetType (budgetTypeId)
)

CREATE TABLE budgetSub (
  budgetSubId INT IDENTITY (1, 1) PRIMARY KEY,
  budgetMasterId INT NOT NULL,
  budgetTypeId INT NOT NULL,
  budgetReferenceId INT NOT NULL,
  created_at DATETIME NOT NULL DEFAULT GETDATE(),
  created_by VARCHAR(255) NOT NULL DEFAULT SUSER_SNAME(),
  updated_at DATETIME,
  updated_by VARCHAR(255),
  CONSTRAINT fk_bsub_bmast FOREIGN KEY (budgetMasterId) REFERENCES budgetMaster (budgetMasterId),
  CONSTRAINT fk_bsub_btype FOREIGN KEY (budgetTypeId) REFERENCES budgetType (budgetTypeId)
)


CREATE TABLE budgetPeriodType (
  budgetPeriodTypeId INT IDENTITY (1, 1) PRIMARY KEY,
  budgetPeriodTypeName VARCHAR(255) UNIQUE,
  created_at DATETIME NOT NULL DEFAULT GETDATE(),
  created_by VARCHAR(255) NOT NULL DEFAULT SUSER_SNAME(),
  updated_at DATETIME,
  updated_by VARCHAR(255)
)


CREATE TABLE budgetDetail (
  budgetDetailId INT IDENTITY (1, 1) PRIMARY KEY,
  budgetMasterId INT NOT NULL,
  budgetSubId INT NULL,
  budgetPeriodTypeId INT NOT NULL DEFAULT 0,
  startDate DATE NOT NULL DEFAULT '1/1/1900',
  endDate DATE NOT NULL DEFAULT '12/31/2199',
  amount MONEY NOT NULL DEFAULT 0,
  created_at DATETIME NOT NULL DEFAULT GETDATE(),
  created_by VARCHAR(255) NOT NULL DEFAULT SUSER_SNAME(),
  updated_at DATETIME,
  updated_by VARCHAR(255)
  CONSTRAINT fk_bdet_bmast FOREIGN KEY (budgetMasterId) REFERENCES budgetMaster (budgetMasterId),
  CONSTRAINT fk_bdet_bsub FOREIGN KEY (budgetSubId) REFERENCES budgetSub (budgetSubId),
  CONSTRAINT fk_bdet_bptype FOREIGN KEY (budgetPeriodTypeId) REFERENCES budgetPeriodType (budgetPeriodTypeId)
)