# 数据字典设计规范

## 数据字典定义

数据字典是数据库中所有数据对象的集合，用于统一团队对数据的理解。

## 核心表设计模板

### 1. 用户表 (users)

| 字段名 | 字段类型 | 必填 | 默认值 | 说明 | 校验规则 |
|--------|----------|------|--------|------|---------|
| id | bigint | 是 | 自增 | 主键ID | - |
| openid | varchar(64) | 是 | - | 微信唯一标识 | 唯一索引 |
| nickname | varchar(50) | 否 | - | 用户昵称 | 最大50字符 |
| avatar | varchar(255) | 否 | - | 头像URL | 有效URL |
| gender | tinyint | 否 | 0 | 性别 | 0未知/1男/2女 |
| phone | varchar(20) | 否 | - | 手机号 | 11位数字 |
| status | tinyint | 是 | 1 | 状态 | 1正常/2禁用 |
| created_at | datetime | 是 | 当前时间 | 创建时间 | - |
| updated_at | datetime | 是 | 当前时间 | 更新时间 | - |
| deleted_at | datetime | 否 | - | 删除时间 | 软删除 |

### 2. 订单表 (orders)

| 字段名 | 字段类型 | 必填 | 默认值 | 说明 | 校验规则 |
|--------|----------|------|--------|------|---------|
| id | bigint | 是 | 自增 | 主键ID | - |
| order_no | varchar(32) | 是 | - | 订单号 | 唯一索引 |
| user_id | bigint | 是 | - | 用户ID | 外键 |
| total_amount | decimal(10,2) | 是 | 0 | 订单金额 | >=0 |
| status | tinyint | 是 | 1 | 订单状态 | 1待支付/2已支付/3已完成/4已取消 |
| paid_at | datetime | 否 | - | 支付时间 | - |
| created_at | datetime | 是 | 当前时间 | 创建时间 | - |
| updated_at | datetime | 是 | 当前时间 | 更新时间 | - |

## 字段类型规范

### 1. 常用数值类型

| 类型 | 存储范围 | 适用场景 |
|------|---------|---------|
| tinyint | -128~127 | 状态、性别 |
| smallint | -32768~32767 | 数量、计数 |
| int | -21亿~21亿 | ID、常规数值 |
| bigint | 极大 | 主键、大数据量 |
| decimal(10,2) | 精确小数 | 金额 |
| float | 单精度 | 评分、坐标 |
| double | 双精度 | 经纬度 |

### 2. 常用字符串类型

| 类型 | 长度 | 适用场景 |
|------|------|---------|
| char(n) | 固定 | 状态码、性别 |
| varchar(n) | 可变 | 名称、描述 |
| text | 大文本 | 文章、内容 |
| json | JSON | 扩展字段 |

### 3. 常用时间类型

| 类型 | 格式 | 适用场景 |
|------|------|---------|
| datetime | Y-m-d H:i:s | 创建/更新时间 |
| timestamp | 时间戳 | 需要时区支持 |
| date | Y-m-d | 日期 |
| time | H:i:s | 时间 |

## 字段规范

### 1. 命名规范

```sql
-- 使用下划线命名
user_id, order_no, created_at

-- 避免使用关键字
-- ❌ desc, order, group
-- ✅ description, order_info, user_group
```

### 2. 必填 vs 可选

| 类型 | 标记 | 说明 |
|------|------|------|
| 必填 | 是 | 必须有值 |
| 可选 | 否 | 可以为空 |
| 有默认值 | 默认值 | 不传时使用默认值 |

### 3. 软删除

```sql
-- 推荐使用 deleted_at 字段
ALTER TABLE users ADD COLUMN deleted_at datetime DEFAULT NULL;

-- 查询时自动过滤
SELECT * FROM users WHERE deleted_at IS NULL;
```

## 索引设计

### 1. 索引类型

| 类型 | 使用场景 |
|------|---------|
| 主键索引 | id 字段，唯一 |
| 唯一索引 | phone, order_no |
| 普通索引 | status, created_at |
| 联合索引 | (user_id, status) |

### 2. 索引示例

```sql
-- 联合索引：用户订单查询
CREATE INDEX idx_user_status ON orders(user_id, status);

-- 全文索引：内容搜索
CREATE FULLTEXT INDEX idx_content ON articles(content);
```

## 关联关系

### 1. 一对一

```sql
-- 用户与用户详情
users.id = user_profiles.user_id
```

### 1. 一对多

```sql
-- 用户与订单
users.id = orders.user_id
```

### 2. 多对多

```sql
-- 用户与角色（通过中间表）
users.id = user_roles.user_id
roles.id = user_roles.role_id
```

## 数据字典文档示例

### 用户模块

```
表名：users
说明：用户基本信息表

| 字段名 | 类型 | 必填 | 说明 |
|--------|------|------|------|
| id | bigint | 是 | 主键 |
| openid | varchar(64) | 是 | 微信openid |
| nickname | varchar(50) | 否 | 昵称 |
...

索引：
- PRIMARY KEY (id)
- UNIQUE KEY uk_openid (openid)
- KEY idx_status (status)
- KEY idx_created_at (created_at)
```

## 常见问题

### 1. 主键设计

```sql
-- 优先使用自增 bigint
id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY

-- 分布式场景使用 UUID
id VARCHAR(36) NOT NULL PRIMARY KEY
```

### 2. 金额设计

```sql
-- 始终使用 decimal
amount DECIMAL(10,2) NOT NULL DEFAULT 0

-- 避免使用 float/double
-- ❌ price FLOAT
-- ✅ price DECIMAL(10,2)
```

### 3. 时间设计

```sql
-- 推荐 datetime
created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
```
