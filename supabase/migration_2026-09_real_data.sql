-- 영업 대시보드: 거래처 마스터 테이블 추가
-- 목적: "①전체 거래처"·"③객단가"를 최근 2개월 실거래 근사치가 아니라
--       실제 등록된 전체 거래처 수 기준으로 계산할 수 있게 합니다.
-- Supabase 대시보드 → SQL Editor 에서 실행하세요.

create table if not exists sales_customers (
  id bigint generated always as identity primary key,
  biz text not null unique,   -- 사업자번호 (없으면 거래처명으로 대체)
  name text not null,         -- 거래처명
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

alter table sales_customers enable row level security;

-- 앞서 다른 테이블들과 동일하게, 사내 URL만 아는 사람이 쓴다는 전제로 anon 쓰기 권한을 엽니다.
create policy "anon write sales_customers" on sales_customers
  for all to anon using (true) with check (true);
