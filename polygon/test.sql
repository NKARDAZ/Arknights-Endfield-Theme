-- ============ 1. КОММЕНТАРИИ ============
-- однострочный комментарий
/* блочный
   многострочный комментарий */

-- ============ 2. СОЗДАНИЕ СХЕМЫ ============
CREATE SCHEMA IF NOT EXISTS theme_test;

-- ============ 3. СОЗДАНИЕ ТАБЛИЦ С РАЗНЫМИ ТИПАМИ ============
CREATE TABLE theme_test.users (
    id SERIAL PRIMARY KEY,
    username VARCHAR(50) NOT NULL UNIQUE,
    email VARCHAR(255) NOT NULL,
    age INTEGER CHECK (age >= 0),
    balance DECIMAL(10, 2) DEFAULT 0.00,
    is_active BOOLEAN DEFAULT TRUE,
    metadata JSONB,
    tags TEXT[],
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NULL
);

CREATE TABLE theme_test.orders (
    id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    user_id INTEGER NOT NULL REFERENCES theme_test.users(id) ON DELETE CASCADE,
    status VARCHAR(20) CHECK (status IN ('pending', 'active', 'done')),
    total_amount NUMERIC(12, 2),
    CONSTRAINT fk_user FOREIGN KEY (user_id) REFERENCES theme_test.users(id)
);

-- ============ 4. ИНДЕКСЫ ============
CREATE INDEX idx_users_email ON theme_test.users (email);
CREATE UNIQUE INDEX idx_users_username ON theme_test.users (username) WHERE is_active = TRUE;

-- ============ 5. ВСТАВКА ДАННЫХ ============
INSERT INTO theme_test.users (username, email, age, balance, is_active, metadata, tags)
VALUES
    ('alice', 'alice@example.com', 25, 100.50, TRUE, '{"role": "admin"}', ARRAY['vip', 'active']),
    ('bob', 'bob@example.com', 30, 0.00, FALSE, NULL, NULL);

-- ============ 6. ВЫБОРКА С РАЗЛИЧНЫМИ ОПЕРАТОРАМИ ============
SELECT
    u.id,
    u.username,
    u.email,
    COUNT(o.id) AS order_count,
    SUM(o.total_amount) AS total_spent,
    CASE
        WHEN u.age < 18 THEN 'несовершеннолетний'
        WHEN u.age BETWEEN 18 AND 65 THEN 'взрослый'
        ELSE 'пенсионер'
    END AS age_group
FROM theme_test.users u
LEFT JOIN theme_test.orders o ON u.id = o.user_id
WHERE u.is_active = TRUE
    AND u.age >= 18
    AND u.username LIKE 'a%'
    AND u.email IS NOT NULL
    AND u.tags && ARRAY['vip']
GROUP BY u.id, u.username, u.email
HAVING COUNT(o.id) > 0
ORDER BY total_spent DESC NULLS LAST
LIMIT 10 OFFSET 0;

-- ============ 7. ПОДЗАПРОСЫ И CTE ============
WITH active_users AS (
    SELECT id, username FROM theme_test.users WHERE is_active = TRUE
),
order_stats AS (
    SELECT user_id, COUNT(*) AS cnt FROM theme_test.orders GROUP BY user_id
)
SELECT au.username, COALESCE(os.cnt, 0) AS orders
FROM active_users au
LEFT JOIN order_stats os ON au.id = os.user_id
WHERE au.id IN (SELECT user_id FROM theme_test.orders WHERE status = 'active');

-- ============ 8. UNION И ОКОННЫЕ ФУНКЦИИ ============
SELECT username, 'active' AS source FROM theme_test.users WHERE is_active = TRUE
UNION ALL
SELECT username, 'inactive' AS source FROM theme_test.users WHERE is_active = FALSE;

SELECT
    username,
    balance,
    RANK() OVER (ORDER BY balance DESC) AS rank,
    ROW_NUMBER() OVER (PARTITION BY is_active ORDER BY created_at) AS row_num,
    LAG(balance) OVER (ORDER BY created_at) AS prev_balance
FROM theme_test.users;

-- ============ 9. ОБНОВЛЕНИЕ И УДАЛЕНИЕ ============
UPDATE theme_test.users
SET balance = balance + 50.00,
    updated_at = NOW()
WHERE id = 1;

DELETE FROM theme_test.orders
WHERE status = 'pending' AND total_amount IS NULL;

-- ============ 10. ФУНКЦИИ И ПРОЦЕДУРЫ ============
CREATE OR REPLACE FUNCTION theme_test.calculate_discount(amount NUMERIC, percent NUMERIC DEFAULT 10)
RETURNS NUMERIC AS $$
BEGIN
    RETURN amount - (amount * percent / 100);
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE VIEW theme_test.active_users_view AS
SELECT id, username, email FROM theme_test.users WHERE is_active = TRUE;

-- ============ 11. ТРАНЗАКЦИИ ============
BEGIN;
    UPDATE theme_test.users SET balance = balance - 100 WHERE id = 1;
    UPDATE theme_test.users SET balance = balance + 100 WHERE id = 2;
COMMIT;

ROLLBACK;

-- ============ 12. ALTER И DROP ============
ALTER TABLE theme_test.users ADD COLUMN phone VARCHAR(20);
ALTER TABLE theme_test.users DROP COLUMN IF EXISTS phone;
DROP TABLE IF EXISTS theme_test.temp_table CASCADE;
DROP INDEX IF EXISTS idx_users_email;
