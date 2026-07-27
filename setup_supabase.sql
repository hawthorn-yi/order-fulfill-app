-- Supabase SQL Setup Script
-- Run this in Supabase Dashboard -> SQL Editor

-- 1. Create suppliers table
CREATE TABLE IF NOT EXISTS suppliers (
  slug TEXT PRIMARY KEY,
  name TEXT NOT NULL,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- 2. Create users table
CREATE TABLE IF NOT EXISTS users (
  username TEXT PRIMARY KEY,
  display_name TEXT,
  password TEXT,
  allowed_suppliers TEXT[] DEFAULT '{}',
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- 3. Create orders table (shared, with supplier_slug for isolation)
CREATE TABLE IF NOT EXISTS orders (
  id TEXT PRIMARY KEY,
  supplier_slug TEXT NOT NULL DEFAULT 'zsjj',
  materialcode TEXT NOT NULL,
  materialname TEXT NOT NULL,
  ponumber TEXT NOT NULL,
  orderdate TEXT,
  purchaseqty DOUBLE PRECISION DEFAULT 0,
  basedeliveredqty DOUBLE PRECISION DEFAULT 0,
  transitqty DOUBLE PRECISION DEFAULT 0,
  initialoutstandingqty DOUBLE PRECISION DEFAULT 0,
  base TEXT DEFAULT '',
  basehistory JSONB DEFAULT '[]',
  supplier_name TEXT DEFAULT '',
  createdat TEXT DEFAULT ''
);

-- 4. Create deliveries table
CREATE TABLE IF NOT EXISTS deliveries (
  id TEXT PRIMARY KEY,
  supplier_slug TEXT NOT NULL DEFAULT 'zsjj',
  orderid TEXT NOT NULL,
  materialcode TEXT NOT NULL,
  materialname TEXT NOT NULL,
  ponumber TEXT NOT NULL,
  quantity DOUBLE PRECISION DEFAULT 0,
  deliverydate TEXT,
  note TEXT DEFAULT '',
  source TEXT DEFAULT '',
  createdat TEXT DEFAULT ''
);

-- 5. Enable RLS (Row Level Security)
ALTER TABLE suppliers ENABLE ROW LEVEL SECURITY;
ALTER TABLE users ENABLE ROW LEVEL SECURITY;
ALTER TABLE orders ENABLE ROW LEVEL SECURITY;
ALTER TABLE deliveries ENABLE ROW LEVEL SECURITY;

-- 6. Create policies for anon access (read/write)
CREATE POLICY "Allow anon read suppliers" ON suppliers FOR SELECT USING (true);
CREATE POLICY "Allow anon insert suppliers" ON suppliers FOR INSERT WITH CHECK (true);
CREATE POLICY "Allow anon update suppliers" ON suppliers FOR UPDATE USING (true);

CREATE POLICY "Allow anon read users" ON users FOR SELECT USING (true);
CREATE POLICY "Allow anon insert users" ON users FOR INSERT WITH CHECK (true);
CREATE POLICY "Allow anon update users" ON users FOR UPDATE USING (true);

CREATE POLICY "Allow anon read orders" ON orders FOR SELECT USING (true);
CREATE POLICY "Allow anon insert orders" ON orders FOR INSERT WITH CHECK (true);
CREATE POLICY "Allow anon update orders" ON orders FOR UPDATE USING (true);
CREATE POLICY "Allow anon delete orders" ON orders FOR DELETE USING (true);

CREATE POLICY "Allow anon read deliveries" ON deliveries FOR SELECT USING (true);
CREATE POLICY "Allow anon insert deliveries" ON deliveries FOR INSERT WITH CHECK (true);
CREATE POLICY "Allow anon update deliveries" ON deliveries FOR UPDATE USING (true);
CREATE POLICY "Allow anon delete deliveries" ON deliveries FOR DELETE USING (true);

-- 7. Insert initial supplier
INSERT INTO suppliers (slug, name) VALUES ('zsjj', '中山嘉建线材') ON CONFLICT DO NOTHING;

-- 8. Insert default admin user
INSERT INTO users (username, display_name, password, allowed_suppliers) VALUES ('admin', '管理员', 'admin123', '{"zsjj"}') ON CONFLICT DO NOTHING;
