-- =====================================================
-- 供应商订单与交付管理系统 - Supabase 建表脚本
-- 在 Supabase Dashboard -> SQL Editor 中执行
-- =====================================================

-- 0. 用户表（用户名+密码登录）
CREATE TABLE IF NOT EXISTS public.app_users (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  username TEXT UNIQUE NOT NULL,
  password_hash TEXT NOT NULL,
  role TEXT NOT NULL DEFAULT 'viewer',
  supplier_codes TEXT[] DEFAULT '{}',
  created_at TIMESTAMPTZ DEFAULT now()
);

ALTER TABLE public.app_users ENABLE ROW LEVEL SECURITY;
DROP POLICY IF EXISTS app_users_public ON public.app_users;
CREATE POLICY app_users_public ON public.app_users
  FOR ALL USING (true) WITH CHECK (true);

-- 预置管理员 admin / admin123
INSERT INTO public.app_users (username, password_hash, role)
VALUES ('admin', 'a1b2c3d4e5f6g7h8:240be518fabd2724ddb6f04eeb1da5967448d7e831c08c8fa822809f74c720a9', 'admin')
ON CONFLICT (username) DO NOTHING;

-- 1. 供应商表
CREATE TABLE IF NOT EXISTS public.suppliers (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  code TEXT UNIQUE NOT NULL,
  name TEXT NOT NULL,
  contact TEXT DEFAULT '',
  phone TEXT DEFAULT '',
  address TEXT DEFAULT '',
  notes TEXT DEFAULT '',
  created_at TIMESTAMPTZ DEFAULT now()
);

ALTER TABLE public.suppliers ENABLE ROW LEVEL SECURITY;
DROP POLICY IF EXISTS suppliers_public ON public.suppliers;
CREATE POLICY suppliers_public ON public.suppliers
  FOR ALL USING (true) WITH CHECK (true);

-- 2. 订单表
CREATE TABLE IF NOT EXISTS public.orders (
  id TEXT PRIMARY KEY,
  materialCode TEXT NOT NULL,
  materialName TEXT NOT NULL,
  poNumber TEXT NOT NULL,
  orderDate TEXT NOT NULL,
  purchaseQty NUMERIC NOT NULL DEFAULT 0,
  baseDeliveredQty NUMERIC NOT NULL DEFAULT 0,
  transitQty NUMERIC NOT NULL DEFAULT 0,
  initialOutstandingQty NUMERIC NOT NULL DEFAULT 0,
  createdAt TEXT NOT NULL DEFAULT '',
  flowConvertedDeliveredQty NUMERIC NOT NULL DEFAULT 0,
  supplierCode TEXT DEFAULT '',
  supplierName TEXT DEFAULT ''
);

-- 3. 交付履历表
CREATE TABLE IF NOT EXISTS public.deliveries (
  id TEXT PRIMARY KEY,
  materialCode TEXT NOT NULL,
  materialName TEXT NOT NULL,
  poNumber TEXT NOT NULL,
  orderId TEXT NOT NULL,
  deliveryDate TEXT NOT NULL,
  quantity NUMERIC NOT NULL DEFAULT 0,
  note TEXT DEFAULT '',
  source TEXT DEFAULT '',
  createdAt TEXT DEFAULT ''
);

-- 4. 在途历史表
CREATE TABLE IF NOT EXISTS public.transit_history (
  id TEXT PRIMARY KEY,
  materialCode TEXT NOT NULL,
  materialName TEXT NOT NULL,
  poNumber TEXT NOT NULL,
  orderId TEXT NOT NULL,
  deliveryDate TEXT NOT NULL,
  quantity NUMERIC NOT NULL DEFAULT 0,
  remainingQty NUMERIC NOT NULL DEFAULT 0,
  note TEXT DEFAULT '',
  source TEXT DEFAULT '',
  createdAt TEXT DEFAULT '',
  receipts JSONB DEFAULT '[]'::jsonb
);

-- 5. 索引
CREATE INDEX IF NOT EXISTS idx_orders_po ON public.orders(poNumber);
CREATE INDEX IF NOT EXISTS idx_orders_material ON public.orders(materialCode);
CREATE INDEX IF NOT EXISTS idx_deliveries_order ON public.deliveries(orderId);
CREATE INDEX IF NOT EXISTS idx_transit_order ON public.transit_history(orderId);

-- =====================================================
-- RLS 策略（授权 anon key 完全访问）
-- =====================================================
ALTER TABLE public.orders ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.deliveries ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.transit_history ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.suppliers ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.app_users ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS orders_public ON public.orders;
CREATE POLICY orders_public ON public.orders
  FOR ALL USING (true) WITH CHECK (true);

DROP POLICY IF EXISTS deliveries_public ON public.deliveries;
CREATE POLICY deliveries_public ON public.deliveries
  FOR ALL USING (true) WITH CHECK (true);

DROP POLICY IF EXISTS transit_history_public ON public.transit_history;
CREATE POLICY transit_history_public ON public.transit_history
  FOR ALL USING (true) WITH CHECK (true);

DROP POLICY IF EXISTS suppliers_public ON public.suppliers;
CREATE POLICY suppliers_public ON public.suppliers
  FOR ALL USING (true) WITH CHECK (true);

DROP POLICY IF EXISTS app_users_public ON public.app_users;
CREATE POLICY app_users_public ON public.app_users
  FOR ALL USING (true) WITH CHECK (true);
