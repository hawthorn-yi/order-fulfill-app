-- Migration v2: delivery status, user roles, supplier policies
-- Run this in Supabase Dashboard -> SQL Editor

-- 1. Add role column to users table
ALTER TABLE users ADD COLUMN IF NOT EXISTS role TEXT DEFAULT 'user';
UPDATE users SET role = 'admin' WHERE username = 'admin';

-- 2. Add delivery status columns
ALTER TABLE deliveries ADD COLUMN IF NOT EXISTS status TEXT DEFAULT '已收货';
ALTER TABLE deliveries ADD COLUMN IF NOT EXISTS confirmedat TEXT;
ALTER TABLE deliveries ADD COLUMN IF NOT EXISTS operator TEXT;
ALTER TABLE deliveries ADD COLUMN IF NOT EXISTS confirmer TEXT;

-- 3. Add DELETE policy for suppliers (was missing)
CREATE POLICY "Allow anon delete suppliers" ON suppliers FOR DELETE USING (true);

-- 4. Drop slug pattern constraint if exists
ALTER TABLE suppliers DROP CONSTRAINT IF EXISTS suppliers_slug_check;
ALTER TABLE suppliers DROP CONSTRAINT IF EXISTS suppliers_slug_pattern_check;
-- Try additional common constraint names from Supabase Dashboard
DO $$ BEGIN
  ALTER TABLE suppliers DROP CONSTRAINT IF EXISTS suppliers_slug_key_check;
EXCEPTION WHEN OTHERS THEN NULL;
END $$;
