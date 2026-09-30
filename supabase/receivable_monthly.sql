-- 채권 대시보드: 월별 미수현황 테이블 추가
-- 목적: 매월 올리는 미회수 엑셀(미수 발생 관리표)의 회사별 요약과 악성미수 거래처 명세를 저장해서,
--       어느 기기에서 열어도 같은 미수현황이 보이고 지난달 기록도 다시 볼 수 있게 합니다.
-- Supabase 대시보드 → SQL Editor 에서 한 번만 실행하세요.

create table if not exists receivable_monthly (
  id bigint generated always as identity primary key,
  company text not null,            -- 회사명 (대상국제교역 / (주)디아이화스너 / 픽스글로벌)
  base_date date not null,          -- 파일의 기준월 (예: 2026-08-31)
  file_name text,                   -- 올린 파일 이름
  sheet_name text,                  -- 읽은 시트 이름
  total numeric not null default 0, -- 전체미수 (거래처 행 합산)
  customer_count int not null default 0,
  by_cat jsonb not null default '{}'::jsonb,        -- {"출고정지":{"amt":..,"n":..}, "해지요청":.., "유지":.., "추심요청":..}
  bad_customers jsonb not null default '[]'::jsonb, -- 악성미수 거래처 명세
  checks jsonb not null default '{}'::jsonb,        -- 파일 점검 결과 (합계행, 원본 구분별 합계 등)
  uploaded_at timestamptz not null default now(),
  unique (company, base_date)
);

alter table receivable_monthly enable row level security;

-- 다른 테이블들과 동일하게, 사내 URL만 아는 사람이 쓴다는 전제로 anon 읽기/쓰기 권한을 엽니다.
create policy "anon write receivable_monthly" on receivable_monthly
  for all to anon using (true) with check (true);
