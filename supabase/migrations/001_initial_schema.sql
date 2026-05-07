-- ============================================================================
-- SPLITZ: Complete Database Schema Migration
-- ============================================================================
-- Run this migration against your Supabase project:
--   supabase db push
-- ============================================================================

-- ============================================================================
-- TABLES
-- ============================================================================

-- profiles table (extends auth.users)
CREATE TABLE IF NOT EXISTS profiles (
  id UUID PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
  full_name TEXT NOT NULL,
  avatar_url TEXT,
  phone TEXT,
  upi_id TEXT,
  fcm_token TEXT,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- groups table
CREATE TABLE IF NOT EXISTS groups (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  name TEXT NOT NULL,
  description TEXT,
  emoji TEXT DEFAULT '💰',
  invite_code TEXT UNIQUE NOT NULL,
  created_by UUID REFERENCES profiles(id),
  currency TEXT DEFAULT 'INR',
  is_active BOOLEAN DEFAULT TRUE,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- group_members table
CREATE TABLE IF NOT EXISTS group_members (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  group_id UUID REFERENCES groups(id) ON DELETE CASCADE,
  user_id UUID REFERENCES profiles(id) ON DELETE CASCADE,
  role TEXT DEFAULT 'member' CHECK (role IN ('admin', 'member')),
  joined_at TIMESTAMPTZ DEFAULT NOW(),
  is_active BOOLEAN DEFAULT TRUE,
  UNIQUE(group_id, user_id)
);

-- wallet_transactions table
CREATE TABLE IF NOT EXISTS wallet_transactions (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  group_id UUID REFERENCES groups(id) ON DELETE CASCADE,
  user_id UUID REFERENCES profiles(id),
  amount BIGINT NOT NULL CHECK (amount > 0),
  type TEXT NOT NULL CHECK (type IN ('credit', 'debit')),
  note TEXT,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- expenses table
CREATE TABLE IF NOT EXISTS expenses (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  group_id UUID REFERENCES groups(id) ON DELETE CASCADE,
  title TEXT NOT NULL,
  amount BIGINT NOT NULL CHECK (amount > 0),
  category TEXT NOT NULL DEFAULT 'general',
  paid_by UUID REFERENCES profiles(id),
  split_type TEXT DEFAULT 'equal' CHECK (split_type IN ('equal', 'unequal', 'percentage', 'exact')),
  date TIMESTAMPTZ DEFAULT NOW(),
  notes TEXT,
  is_deleted BOOLEAN DEFAULT FALSE,
  created_by UUID REFERENCES profiles(id),
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- expense_participants table
CREATE TABLE IF NOT EXISTS expense_participants (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  expense_id UUID REFERENCES expenses(id) ON DELETE CASCADE,
  user_id UUID REFERENCES profiles(id),
  share_amount BIGINT NOT NULL,
  share_percentage NUMERIC(5, 2),
  is_settled BOOLEAN DEFAULT FALSE,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  UNIQUE(expense_id, user_id)
);

-- settlements table
CREATE TABLE IF NOT EXISTS settlements (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  group_id UUID REFERENCES groups(id) ON DELETE CASCADE,
  from_user UUID REFERENCES profiles(id),
  to_user UUID REFERENCES profiles(id),
  amount BIGINT NOT NULL CHECK (amount > 0),
  is_paid BOOLEAN DEFAULT FALSE,
  paid_at TIMESTAMPTZ,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- notifications table
CREATE TABLE IF NOT EXISTS notifications (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID REFERENCES profiles(id) ON DELETE CASCADE,
  group_id UUID REFERENCES groups(id),
  type TEXT NOT NULL,
  title TEXT NOT NULL,
  body TEXT,
  data JSONB,
  is_read BOOLEAN DEFAULT FALSE,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- ============================================================================
-- INDEXES
-- ============================================================================

CREATE INDEX IF NOT EXISTS idx_group_members_group_id ON group_members(group_id);
CREATE INDEX IF NOT EXISTS idx_group_members_user_id ON group_members(user_id);
CREATE INDEX IF NOT EXISTS idx_expenses_group_id ON expenses(group_id);
CREATE INDEX IF NOT EXISTS idx_expenses_paid_by ON expenses(paid_by);
CREATE INDEX IF NOT EXISTS idx_expense_participants_expense_id ON expense_participants(expense_id);
CREATE INDEX IF NOT EXISTS idx_expense_participants_user_id ON expense_participants(user_id);
CREATE INDEX IF NOT EXISTS idx_wallet_transactions_group_id ON wallet_transactions(group_id);
CREATE INDEX IF NOT EXISTS idx_wallet_transactions_user_id ON wallet_transactions(user_id);
CREATE INDEX IF NOT EXISTS idx_settlements_group_id ON settlements(group_id);
CREATE INDEX IF NOT EXISTS idx_settlements_from_user ON settlements(from_user);
CREATE INDEX IF NOT EXISTS idx_settlements_to_user ON settlements(to_user);
CREATE INDEX IF NOT EXISTS idx_notifications_user_id ON notifications(user_id);
CREATE INDEX IF NOT EXISTS idx_notifications_is_read ON notifications(user_id, is_read);
CREATE INDEX IF NOT EXISTS idx_groups_invite_code ON groups(invite_code);

-- ============================================================================
-- ROW LEVEL SECURITY
-- ============================================================================

-- ---- PROFILES ----
ALTER TABLE profiles ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users can view their own profile"
ON profiles FOR SELECT
USING (id = auth.uid());

CREATE POLICY "Users can view profiles of group co-members"
ON profiles FOR SELECT
USING (
  id IN (
    SELECT gm2.user_id FROM group_members gm1
    JOIN group_members gm2 ON gm1.group_id = gm2.group_id
    WHERE gm1.user_id = auth.uid() AND gm1.is_active = TRUE AND gm2.is_active = TRUE
  )
);

CREATE POLICY "Users can insert their own profile"
ON profiles FOR INSERT
WITH CHECK (id = auth.uid());

CREATE POLICY "Users can update their own profile"
ON profiles FOR UPDATE
USING (id = auth.uid())
WITH CHECK (id = auth.uid());

-- ---- GROUPS ----
ALTER TABLE groups ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Group members can view their groups"
ON groups FOR SELECT
USING (
  id IN (
    SELECT group_id FROM group_members
    WHERE user_id = auth.uid() AND is_active = TRUE
  )
);

CREATE POLICY "Any authenticated user can view group by invite code"
ON groups FOR SELECT
USING (auth.uid() IS NOT NULL);

CREATE POLICY "Authenticated users can create groups"
ON groups FOR INSERT
WITH CHECK (auth.uid() IS NOT NULL AND created_by = auth.uid());

CREATE POLICY "Group admins can update groups"
ON groups FOR UPDATE
USING (
  id IN (
    SELECT group_id FROM group_members
    WHERE user_id = auth.uid() AND role = 'admin' AND is_active = TRUE
  )
);

-- ---- GROUP_MEMBERS ----
ALTER TABLE group_members ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Group members can view members of their groups"
ON group_members FOR SELECT
USING (
  group_id IN (
    SELECT group_id FROM group_members
    WHERE user_id = auth.uid() AND is_active = TRUE
  )
);

CREATE POLICY "Authenticated users can join groups"
ON group_members FOR INSERT
WITH CHECK (auth.uid() IS NOT NULL AND user_id = auth.uid());

CREATE POLICY "Users can update their own membership"
ON group_members FOR UPDATE
USING (user_id = auth.uid());

CREATE POLICY "Group admins can update any membership"
ON group_members FOR UPDATE
USING (
  group_id IN (
    SELECT group_id FROM group_members
    WHERE user_id = auth.uid() AND role = 'admin' AND is_active = TRUE
  )
);

-- ---- WALLET_TRANSACTIONS ----
ALTER TABLE wallet_transactions ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Group members can view wallet transactions"
ON wallet_transactions FOR SELECT
USING (
  group_id IN (
    SELECT group_id FROM group_members
    WHERE user_id = auth.uid() AND is_active = TRUE
  )
);

CREATE POLICY "Group members can insert wallet transactions"
ON wallet_transactions FOR INSERT
WITH CHECK (
  group_id IN (
    SELECT group_id FROM group_members
    WHERE user_id = auth.uid() AND is_active = TRUE
  )
  AND user_id = auth.uid()
);

-- ---- EXPENSES ----
ALTER TABLE expenses ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Group members can view expenses"
ON expenses FOR SELECT
USING (
  group_id IN (
    SELECT group_id FROM group_members
    WHERE user_id = auth.uid() AND is_active = TRUE
  )
);

CREATE POLICY "Group members can insert expenses"
ON expenses FOR INSERT
WITH CHECK (
  group_id IN (
    SELECT group_id FROM group_members
    WHERE user_id = auth.uid() AND is_active = TRUE
  )
  AND created_by = auth.uid()
);

CREATE POLICY "Expense creator can update expenses"
ON expenses FOR UPDATE
USING (created_by = auth.uid());

CREATE POLICY "Expense creator can delete expenses"
ON expenses FOR DELETE
USING (created_by = auth.uid());

-- ---- EXPENSE_PARTICIPANTS ----
ALTER TABLE expense_participants ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Group members can view expense participants"
ON expense_participants FOR SELECT
USING (
  expense_id IN (
    SELECT e.id FROM expenses e
    JOIN group_members gm ON e.group_id = gm.group_id
    WHERE gm.user_id = auth.uid() AND gm.is_active = TRUE
  )
);

CREATE POLICY "Group members can insert expense participants"
ON expense_participants FOR INSERT
WITH CHECK (
  expense_id IN (
    SELECT e.id FROM expenses e
    JOIN group_members gm ON e.group_id = gm.group_id
    WHERE gm.user_id = auth.uid() AND gm.is_active = TRUE
  )
);

CREATE POLICY "Expense participants can be updated by expense creator"
ON expense_participants FOR UPDATE
USING (
  expense_id IN (
    SELECT id FROM expenses WHERE created_by = auth.uid()
  )
);

CREATE POLICY "Expense participants can be deleted by expense creator"
ON expense_participants FOR DELETE
USING (
  expense_id IN (
    SELECT id FROM expenses WHERE created_by = auth.uid()
  )
);

-- ---- SETTLEMENTS ----
ALTER TABLE settlements ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Group members can view settlements"
ON settlements FOR SELECT
USING (
  group_id IN (
    SELECT group_id FROM group_members
    WHERE user_id = auth.uid() AND is_active = TRUE
  )
);

CREATE POLICY "Group members can insert settlements"
ON settlements FOR INSERT
WITH CHECK (
  group_id IN (
    SELECT group_id FROM group_members
    WHERE user_id = auth.uid() AND is_active = TRUE
  )
);

CREATE POLICY "Settlement participants can update settlements"
ON settlements FOR UPDATE
USING (from_user = auth.uid() OR to_user = auth.uid());

-- ---- NOTIFICATIONS ----
ALTER TABLE notifications ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users can view their own notifications"
ON notifications FOR SELECT
USING (user_id = auth.uid());

CREATE POLICY "System can insert notifications for any user"
ON notifications FOR INSERT
WITH CHECK (auth.uid() IS NOT NULL);

CREATE POLICY "Users can update their own notifications"
ON notifications FOR UPDATE
USING (user_id = auth.uid());

CREATE POLICY "Users can delete their own notifications"
ON notifications FOR DELETE
USING (user_id = auth.uid());

-- ============================================================================
-- FUNCTIONS
-- ============================================================================

-- Function: Auto-update updated_at timestamp
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Function: Generate a unique invite code
CREATE OR REPLACE FUNCTION generate_invite_code()
RETURNS TEXT AS $$
DECLARE
  new_code TEXT;
  code_exists BOOLEAN;
BEGIN
  LOOP
    new_code := upper(substr(md5(random()::text || clock_timestamp()::text), 1, 6));
    SELECT EXISTS(SELECT 1 FROM groups WHERE invite_code = new_code) INTO code_exists;
    EXIT WHEN NOT code_exists;
  END LOOP;
  RETURN new_code;
END;
$$ LANGUAGE plpgsql;

-- Function: Calculate net balances for a group
CREATE OR REPLACE FUNCTION calculate_net_balances(p_group_id UUID)
RETURNS TABLE(user_id UUID, full_name TEXT, net_balance BIGINT) AS $$
BEGIN
  RETURN QUERY
  WITH member_list AS (
    SELECT gm.user_id AS uid, p.full_name AS fname
    FROM group_members gm
    JOIN profiles p ON p.id = gm.user_id
    WHERE gm.group_id = p_group_id AND gm.is_active = TRUE
  ),
  total_paid AS (
    SELECT e.paid_by AS uid, COALESCE(SUM(e.amount), 0)::BIGINT AS paid
    FROM expenses e
    WHERE e.group_id = p_group_id AND e.is_deleted = FALSE
    GROUP BY e.paid_by
  ),
  total_owed AS (
    SELECT ep.user_id AS uid, COALESCE(SUM(ep.share_amount), 0)::BIGINT AS owed
    FROM expense_participants ep
    JOIN expenses e ON e.id = ep.expense_id
    WHERE e.group_id = p_group_id AND e.is_deleted = FALSE
    GROUP BY ep.user_id
  )
  SELECT
    ml.uid AS user_id,
    ml.fname AS full_name,
    (COALESCE(tp.paid, 0) - COALESCE(tow.owed, 0))::BIGINT AS net_balance
  FROM member_list ml
  LEFT JOIN total_paid tp ON tp.uid = ml.uid
  LEFT JOIN total_owed tow ON tow.uid = ml.uid
  ORDER BY net_balance DESC;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Function: Generate optimized settlements (greedy algorithm)
CREATE OR REPLACE FUNCTION generate_settlements(p_group_id UUID)
RETURNS TABLE(from_user UUID, to_user UUID, amount BIGINT) AS $$
DECLARE
  creditors RECORD;
  debtors RECORD;
  cred_arr UUID[];
  cred_bal BIGINT[];
  debt_arr UUID[];
  debt_bal BIGINT[];
  ci INTEGER := 1;
  di INTEGER := 1;
  settle_amount BIGINT;
  cred_count INTEGER;
  debt_count INTEGER;
BEGIN
  -- Build creditor arrays (positive net balance = others owe them)
  SELECT array_agg(nb.user_id), array_agg(nb.net_balance)
  INTO cred_arr, cred_bal
  FROM calculate_net_balances(p_group_id) nb
  WHERE nb.net_balance > 0
  ORDER BY nb.net_balance DESC;

  -- Build debtor arrays (negative net balance = they owe others)
  SELECT array_agg(nb.user_id), array_agg(abs(nb.net_balance))
  INTO debt_arr, debt_bal
  FROM calculate_net_balances(p_group_id) nb
  WHERE nb.net_balance < 0
  ORDER BY nb.net_balance ASC;

  -- Handle null arrays
  IF cred_arr IS NULL OR debt_arr IS NULL THEN
    RETURN;
  END IF;

  cred_count := array_length(cred_arr, 1);
  debt_count := array_length(debt_arr, 1);

  -- Greedy matching
  WHILE ci <= cred_count AND di <= debt_count LOOP
    IF cred_bal[ci] <= 0 THEN
      ci := ci + 1;
      CONTINUE;
    END IF;
    IF debt_bal[di] <= 0 THEN
      di := di + 1;
      CONTINUE;
    END IF;

    settle_amount := LEAST(cred_bal[ci], debt_bal[di]);

    from_user := debt_arr[di];
    to_user := cred_arr[ci];
    amount := settle_amount;
    RETURN NEXT;

    cred_bal[ci] := cred_bal[ci] - settle_amount;
    debt_bal[di] := debt_bal[di] - settle_amount;

    IF cred_bal[ci] = 0 THEN
      ci := ci + 1;
    END IF;
    IF debt_bal[di] = 0 THEN
      di := di + 1;
    END IF;
  END LOOP;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Function: Get group summary as JSON
CREATE OR REPLACE FUNCTION get_group_summary(p_group_id UUID)
RETURNS JSON AS $$
DECLARE
  result JSON;
BEGIN
  SELECT json_build_object(
    'total_expenses', (
      SELECT COALESCE(SUM(amount), 0)
      FROM expenses
      WHERE group_id = p_group_id AND is_deleted = FALSE
    ),
    'wallet_balance', (
      SELECT COALESCE(SUM(
        CASE WHEN type = 'credit' THEN amount ELSE -amount END
      ), 0)
      FROM wallet_transactions
      WHERE group_id = p_group_id
    ),
    'member_count', (
      SELECT COUNT(*)
      FROM group_members
      WHERE group_id = p_group_id AND is_active = TRUE
    ),
    'settlement_count', (
      SELECT COUNT(*)
      FROM settlements
      WHERE group_id = p_group_id AND is_paid = FALSE
    ),
    'top_spender', (
      SELECT json_build_object('user_id', e.paid_by, 'full_name', p.full_name, 'total', SUM(e.amount))
      FROM expenses e
      JOIN profiles p ON p.id = e.paid_by
      WHERE e.group_id = p_group_id AND e.is_deleted = FALSE
      GROUP BY e.paid_by, p.full_name
      ORDER BY SUM(e.amount) DESC
      LIMIT 1
    )
  ) INTO result;
  RETURN result;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Function: Handle new user creation (auto-create profile)
CREATE OR REPLACE FUNCTION handle_new_user()
RETURNS TRIGGER AS $$
BEGIN
  INSERT INTO profiles (id, full_name, avatar_url)
  VALUES (
    NEW.id,
    COALESCE(NEW.raw_user_meta_data->>'full_name', 'User'),
    NEW.raw_user_meta_data->>'avatar_url'
  );
  RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- ============================================================================
-- TRIGGERS
-- ============================================================================

-- Auto-update updated_at on profiles
CREATE TRIGGER set_profiles_updated_at
  BEFORE UPDATE ON profiles
  FOR EACH ROW
  EXECUTE FUNCTION update_updated_at_column();

-- Auto-update updated_at on groups
CREATE TRIGGER set_groups_updated_at
  BEFORE UPDATE ON groups
  FOR EACH ROW
  EXECUTE FUNCTION update_updated_at_column();

-- Auto-update updated_at on expenses
CREATE TRIGGER set_expenses_updated_at
  BEFORE UPDATE ON expenses
  FOR EACH ROW
  EXECUTE FUNCTION update_updated_at_column();

-- Auto-update updated_at on settlements
CREATE TRIGGER set_settlements_updated_at
  BEFORE UPDATE ON settlements
  FOR EACH ROW
  EXECUTE FUNCTION update_updated_at_column();

-- Auto-create profile on user signup
CREATE TRIGGER on_auth_user_created
  AFTER INSERT ON auth.users
  FOR EACH ROW
  EXECUTE FUNCTION handle_new_user();

-- Notification trigger function: on new expense
CREATE OR REPLACE FUNCTION notify_group_on_expense()
RETURNS TRIGGER AS $$
DECLARE
  member_record RECORD;
  group_name TEXT;
  expense_title TEXT;
  payer_name TEXT;
BEGIN
  SELECT name INTO group_name FROM groups WHERE id = NEW.group_id;
  SELECT full_name INTO payer_name FROM profiles WHERE id = NEW.paid_by;
  expense_title := NEW.title;

  FOR member_record IN
    SELECT user_id FROM group_members
    WHERE group_id = NEW.group_id AND is_active = TRUE AND user_id != NEW.created_by
  LOOP
    INSERT INTO notifications (user_id, group_id, type, title, body, data)
    VALUES (
      member_record.user_id,
      NEW.group_id,
      'expense_added',
      'New expense in ' || group_name,
      payer_name || ' added "' || expense_title || '" for ₹' || (NEW.amount / 100.0)::TEXT,
      json_build_object(
        'expense_id', NEW.id,
        'group_id', NEW.group_id,
        'amount', NEW.amount
      )::JSONB
    );
  END LOOP;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

CREATE TRIGGER on_expense_created
  AFTER INSERT ON expenses
  FOR EACH ROW
  EXECUTE FUNCTION notify_group_on_expense();

-- Notification trigger function: on new group member
CREATE OR REPLACE FUNCTION notify_group_on_member_join()
RETURNS TRIGGER AS $$
DECLARE
  member_record RECORD;
  joiner_name TEXT;
  group_name TEXT;
BEGIN
  SELECT full_name INTO joiner_name FROM profiles WHERE id = NEW.user_id;
  SELECT name INTO group_name FROM groups WHERE id = NEW.group_id;

  FOR member_record IN
    SELECT user_id FROM group_members
    WHERE group_id = NEW.group_id AND is_active = TRUE AND user_id != NEW.user_id
  LOOP
    INSERT INTO notifications (user_id, group_id, type, title, body, data)
    VALUES (
      member_record.user_id,
      NEW.group_id,
      'member_joined',
      joiner_name || ' joined ' || group_name,
      joiner_name || ' has joined the group!',
      json_build_object('group_id', NEW.group_id, 'user_id', NEW.user_id)::JSONB
    );
  END LOOP;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

CREATE TRIGGER on_group_member_joined
  AFTER INSERT ON group_members
  FOR EACH ROW
  EXECUTE FUNCTION notify_group_on_member_join();

-- ============================================================================
-- ENABLE REALTIME
-- ============================================================================

ALTER PUBLICATION supabase_realtime ADD TABLE expenses;
ALTER PUBLICATION supabase_realtime ADD TABLE expense_participants;
ALTER PUBLICATION supabase_realtime ADD TABLE wallet_transactions;
ALTER PUBLICATION supabase_realtime ADD TABLE group_members;
ALTER PUBLICATION supabase_realtime ADD TABLE settlements;
ALTER PUBLICATION supabase_realtime ADD TABLE notifications;
