-- 영업 대시보드: 월별 "거래처별 매출" 히스토리 테이블 추가
-- 목적: 9월부터는 그 달 자료 1개만 올려도, 저장된 전달 거래처별 매출과 자동으로
--       비교할 수 있도록 거래처×월 단위 매출을 별도로 누적 저장합니다.
-- Supabase 대시보드 → SQL Editor 에서 실행하세요.

create table if not exists sales_customer_monthly (
  id bigint generated always as identity primary key,
  biz text not null,           -- 사업자번호 (없으면 거래처명으로 대체)
  name text not null,          -- 거래처명
  year int not null,           -- 예: 2026
  month_num int not null,      -- 1~12
  amount bigint not null default 0,  -- 그 달 매출액(원, 금액=부가세 제외 공급가액)
  updated_at timestamptz not null default now(),
  unique (biz, year, month_num)
);

alter table sales_customer_monthly enable row level security;

-- 앞서 sales_monthly/sales_pipeline/sales_rank에 연 것과 동일하게,
-- 사내 URL만 아는 사람이 쓴다는 전제로 anon 쓰기 권한을 엽니다.
create policy "anon write sales_customer_monthly" on sales_customer_monthly
  for all to anon using (true) with check (true);
