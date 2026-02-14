# API 设计规范

## API 设计流程

```
需求分析 -> 接口定义 -> 评审 -> 实现 -> 测试
```

## RESTful API 规范

### 1. URL 命名

| 方法 | 用途 | 示例 |
|------|------|------|
| GET | 获取资源 | GET /users |
| POST | 创建资源 | POST /users |
| PUT | 完整更新 | PUT /users/1 |
| PATCH | 部分更新 | PATCH /users/1 |
| DELETE | 删除资源 | DELETE /users/1 |

### 2. 资源命名

```
# 复数形式
/users
/orders
/products

# 嵌套关系
/users/1/orders
/products/1/comments

# 避免动词
# ❌ GET /getUsers
# ✅ GET /users
```

### 3. 状态码

| 状态码 | 含义 | 使用场景 |
|--------|------|---------|
| 200 | OK | 成功获取/更新 |
| 201 | Created | 成功创建 |
| 204 | No Content | 成功删除 |
| 400 | Bad Request | 参数错误 |
| 401 | Unauthorized | 未登录 |
| 403 | Forbidden | 无权限 |
| 404 | Not Found | 资源不存在 |
| 500 | Server Error | 服务器错误 |

## 接口文档模板

### 1. 创建接口

```markdown
### POST /api/v1/{resource}

创建{资源名称}

**请求参数**

| 参数名 | 类型 | 必填 | 说明 | 校验规则 |
|--------|------|------|------|---------|
| name | string | 是 | 名称 | 1-50字符 |
| type | int | 是 | 类型 | 1-正常,2-禁用 |

**请求示例**
```json
{
  "name": "测试",
  "type": 1
}
```

**响应示例**
```json
{
  "code": 201,
  "message": "创建成功",
  "data": {
    "id": 1,
    "name": "测试",
    "type": 1,
    "created_at": "2026-02-14 10:00:00"
  }
}
```

**错误码**
| code | message | 说明 |
|------|---------|------|
| 40001 | 参数错误 | 必填参数缺失 |
| 40002 | 参数错误 | name 超过长度限制 |
```

### 2. 查询接口

```markdown
### GET /api/v1/{resource}

获取{资源名称}列表

**查询参数**

| 参数名 | 类型 | 必填 | 说明 | 默认值 |
|--------|------|------|------|-------|
| page | int | 否 | 页码 | 1 |
| page_size | int | 否 | 每页数量 | 20 |
| keyword | string | 否 | 关键词搜索 | - |
| status | int | 否 | 状态筛选 | - |

**响应示例**
```json
{
  "code": 200,
  "message": "success",
  "data": {
    "list": [
      {
        "id": 1,
        "name": "测试",
        "status": 1
      }
    ],
    "pagination": {
      "page": 1,
      "page_size": 20,
      "total": 100
    }
  }
}
```
```

## API 版本管理

### URL 版本

```
/api/v1/users
/api/v2/users
```

### 适用场景

| 版本策略 | 适用场景 |
|---------|---------|
| URL 版本 | 重大变更 |
| Header 版本 | 微调 |
| 参数版本 | 小改动 |

## 错误响应规范

### 1. 错误格式

```json
{
  "code": 40001,
  "message": "用户不存在",
  "detail": {
    "field": "user_id",
    "reason": "ID 格式错误"
  }
}
```

### 2. 错误码规范

```
{模块}{序号}
示例：
- USER001: 用户模块错误
- ORDER001: 订单模块错误
- COMMON001: 通用错误
```

### 3. 通用错误码

| 错误码 | 消息 | 说明 |
|--------|------|------|
| COMMON001 | 参数错误 | 请求参数有误 |
| COMMON002 | 签名错误 | 签名验证失败 |
| COMMON003 | 权限不足 | 无操作权限 |
| COMMON004 | 资源不存在 | 请求的资源不存在 |
| COMMON005 | 请求过于频繁 | 触发限流 |
| COMMON500 | 系统错误 | 服务器内部错误 |

## 接口安全

### 1. 认证方式

| 方式 | 适用场景 |
|------|---------|
| Bearer Token | REST API |
| API Key | 服务间调用 |
| OAuth 2.0 | 第三方登录 |

### 2. 限流策略

```yaml
rate_limit:
  default: 100/minute
  authenticated: 1000/minute
  premium: 5000/minute
```

### 3. 敏感数据

- 密码：传输/存储加密
- 手机号：脱敏处理
- 身份证：脱敏处理

## 性能优化

### 1. 分页

```json
{
  "list": [],
  "pagination": {
    "page": 1,
    "page_size": 20,
    "total": 1000,
    "has_more": true
  }
}
```

### 2. 字段过滤

```
GET /users?fields=id,name,email
GET /users?exclude=password,token
```

### 3. 缓存策略

| 资源 | 缓存时间 |
|------|---------|
| 列表数据 | 1-5 分钟 |
| 详情数据 | 5-15 分钟 |
| 配置数据 | 1-24 小时 |
| 用户数据 | 不缓存 |
