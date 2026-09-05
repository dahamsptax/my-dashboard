-- 영업 대시보드: 실데이터(거래처별 매출 원장) 연동을 위한 스키마 변경
-- Supabase 대시보드 → SQL Editor 에서 실행하세요.
-- (다함님 세션의 Claude는 이 SQL을 실행할 쓰기 권한이 없어 직접 실행이 필요합니다.)

-- 1) sales_monthly: KPI ③객단가·④매출평균증감율 계산에 필요한 컬럼 추가
alter table sales_monthly add column if not exists total_customers integer;
alter table sales_monthly add column if not exists avg_growth_rate numeric;

-- 2) sales_rank: "매출증감율 상위 거래처" 표시를 위한 증감율(%) 컬럼 추가
--    (기존 amount 컬럼은 그대로 두고, gainer 항목은 amount=이번달매출(만원), rate=증감율(%) 로 채웁니다)
alter table sales_rank add column if not exists rate numeric;

-- sales_pipeline 은 컬럼 변경 없이 그대로 재사용합니다 (stage 텍스트만 새 값으로 교체).


-- =====================================================================
-- 3) 쓰기 권한(RLS) — 엑셀 업로드 화면이 저장하려면 아래 정책이 필요합니다.
-- ⚠️ 주의: 이 사이트는 로그인이 없고, anon key가 페이지 소스에 공개되어 있습니다.
--    아래 정책을 그대로 열면, 이 사이트 주소를 아는 "누구나" API로 직접 데이터를
--    덮어쓸 수 있게 됩니다. 사내에서만 URL을 아는 상황이라 위험을 감수할 수 있다면
--    아래 정책을 실행하시고, 더 안전하게 가고 싶다면 실행하지 말고 Claude에게
--    "업로드 화면에 로그인을 추가해줘"라고 요청해주세요 (Supabase Auth로 다함님
--    계정만 쓰기 가능하도록 제한하는 작업을 별도로 진행하겠습니다).

-- create policy "anon write sales_monthly" on sales_monthly
--   for all to anon using (true) with check (true);
-- create policy "anon write sales_pipeline" on sales_pipeline
--   for all to anon using (true) with check (true);
-- create policy "anon write sales_rank" on sales_rank
--   for all to anon using (true) with check (true);
