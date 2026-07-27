-- =====================================================
-- ?????????? - Supabase ????????
-- ? Supabase Dashboard -> SQL Editor ??????
-- =====================================================
-- 1. ???
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
  flowConvertedDeliveredQty NUMERIC NOT NULL DEFAULT 0
);
-- 2. ???????????
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
  createdAt TEXT DEFAULT '',
  confirmed BOOLEAN DEFAULT false
);
-- 3. ???????????
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
-- 4. ??
CREATE INDEX IF NOT EXISTS idx_orders_po ON public.orders(poNumber);
CREATE INDEX IF NOT EXISTS idx_orders_material ON public.orders(materialCode);
CREATE INDEX IF NOT EXISTS idx_deliveries_order ON public.deliveries(orderId);
CREATE INDEX IF NOT EXISTS idx_transit_order ON public.transit_history(orderId);
-- =====================================================
-- RLS ????? anon key ???
-- =====================================================
ALTER TABLE public.orders ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.deliveries ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.transit_history ENABLE ROW LEVEL SECURITY;
DROP POLICY IF EXISTS orders_public ON public.orders;
CREATE POLICY orders_public ON public.orders
  FOR ALL USING (true) WITH CHECK (true);
DROP POLICY IF EXISTS deliveries_public ON public.deliveries;
CREATE POLICY deliveries_public ON public.deliveries
  FOR ALL USING (true) WITH CHECK (true);
DROP POLICY IF EXISTS transit_history_public ON public.transit_history;
CREATE POLICY transit_history_public ON public.transit_history
  FOR ALL USING (true) WITH CHECK (true);