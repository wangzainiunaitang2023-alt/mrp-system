-- 先确保使用正确的数据库
USE mrp_inventory_system;

-- 1. 角色表
CREATE TABLE IF NOT EXISTS roles (
  id INT PRIMARY KEY AUTO_INCREMENT,
  name VARCHAR(50) NOT NULL UNIQUE,
  description TEXT,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 2. 用户表
CREATE TABLE IF NOT EXISTS users (
  id INT PRIMARY KEY AUTO_INCREMENT,
  username VARCHAR(50) NOT NULL UNIQUE,
  password VARCHAR(255) NOT NULL,
  email VARCHAR(100),
  role_id INT,
  status ENUM('active', 'inactive') DEFAULT 'active',
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (role_id) REFERENCES roles(id)
);

-- 3. 供应商表
CREATE TABLE IF NOT EXISTS suppliers (
  id INT PRIMARY KEY AUTO_INCREMENT,
  name VARCHAR(100) NOT NULL,
  contact_person VARCHAR(50),
  phone VARCHAR(20),
  email VARCHAR(100),
  address TEXT,
  status ENUM('active', 'inactive') DEFAULT 'active',
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 4. 物料表
CREATE TABLE IF NOT EXISTS materials (
  id INT PRIMARY KEY AUTO_INCREMENT,
  name VARCHAR(100) NOT NULL,
  code VARCHAR(50) NOT NULL UNIQUE,
  category VARCHAR(50),
  unit VARCHAR(20),
  stock INT DEFAULT 0,
  safety_stock INT DEFAULT 0,
  supplier_id INT,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (supplier_id) REFERENCES suppliers(id)
);

-- 5. 库存交易记录表
CREATE TABLE IF NOT EXISTS inventory_transactions (
  id INT PRIMARY KEY AUTO_INCREMENT,
  material_id INT NOT NULL,
  type ENUM('in', 'out') NOT NULL,
  quantity INT NOT NULL,
  related_order_id INT,
  remark TEXT,
  created_by INT,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (material_id) REFERENCES materials(id),
  FOREIGN KEY (created_by) REFERENCES users(id)
);

-- 6. 采购申请表
CREATE TABLE IF NOT EXISTS purchase_requests (
  id INT PRIMARY KEY AUTO_INCREMENT,
  request_no VARCHAR(50) NOT NULL UNIQUE,
  status ENUM('draft', 'pending', 'approved', 'rejected') DEFAULT 'draft',
  created_by INT NOT NULL,
  approved_by INT,
  approved_at TIMESTAMP NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (created_by) REFERENCES users(id),
  FOREIGN KEY (approved_by) REFERENCES users(id)
);

-- 7. 采购申请明细表
CREATE TABLE IF NOT EXISTS purchase_request_items (
  id INT PRIMARY KEY AUTO_INCREMENT,
  request_id INT NOT NULL,
  material_id INT NOT NULL,
  quantity INT NOT NULL,
  FOREIGN KEY (request_id) REFERENCES purchase_requests(id),
  FOREIGN KEY (material_id) REFERENCES materials(id)
);

-- 8. 审批历史表
CREATE TABLE IF NOT EXISTS approval_history (
  id INT PRIMARY KEY AUTO_INCREMENT,
  request_id INT NOT NULL,
  approver_id INT NOT NULL,
  action ENUM('approve', 'reject') NOT NULL,
  remark TEXT,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (request_id) REFERENCES purchase_requests(id),
  FOREIGN KEY (approver_id) REFERENCES users(id)
);

-- 9. 审计日志表
CREATE TABLE IF NOT EXISTS audit_logs (
  id INT PRIMARY KEY AUTO_INCREMENT,
  user_id INT,
  action VARCHAR(100) NOT NULL,
  resource_type VARCHAR(50),
  resource_id INT,
  ip_address VARCHAR(50),
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (user_id) REFERENCES users(id)
);

-- 10. 通知表
CREATE TABLE IF NOT EXISTS notifications (
  id INT PRIMARY KEY AUTO_INCREMENT,
  user_id INT NOT NULL,
  title VARCHAR(100) NOT NULL,
  content TEXT,
  is_read BOOLEAN DEFAULT FALSE,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (user_id) REFERENCES users(id)
);

-- 11. 系统设置表
CREATE TABLE IF NOT EXISTS settings (
  id INT PRIMARY KEY AUTO_INCREMENT,
  `key` VARCHAR(50) NOT NULL UNIQUE,
  value TEXT,
  description TEXT,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);