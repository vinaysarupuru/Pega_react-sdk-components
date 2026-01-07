/// Pega Flutter SDK Components
///
/// This package contains the source code for the Pega-provided bridge
/// from the Constellation Engine to the DX components.
/// The DX Components are a reference implementation that use Flutter's
/// Material Design system.
library pega_flutter_sdk_components;

// Bridge exports
export 'src/bridge/pconnect.dart';
export 'src/bridge/pconnect_state.dart';
export 'src/bridge/component_map.dart';
export 'src/bridge/actions_api.dart';

// Types exports
export 'src/types/pconn_props.dart';
export 'src/types/pconn_field_props.dart';

// Field components exports
export 'src/components/field/text_input.dart';
export 'src/components/field/checkbox.dart';
export 'src/components/field/dropdown.dart';
export 'src/components/field/date_picker.dart';
export 'src/components/field/date_time_picker.dart';
export 'src/components/field/time_picker.dart';
export 'src/components/field/email.dart';
export 'src/components/field/phone.dart';
export 'src/components/field/url_field.dart';
export 'src/components/field/text_area.dart';
export 'src/components/field/currency.dart';
export 'src/components/field/decimal.dart';
export 'src/components/field/integer.dart';
export 'src/components/field/percentage.dart';
export 'src/components/field/radio_buttons.dart';
export 'src/components/field/auto_complete.dart';
export 'src/components/field/rich_text.dart';

// Template components exports
export 'src/components/template/one_column.dart';
export 'src/components/template/two_column.dart';
export 'src/components/template/wide_narrow.dart';
export 'src/components/template/narrow_wide.dart';
export 'src/components/template/default_form.dart';
export 'src/components/template/case_view.dart';
export 'src/components/template/case_summary.dart';
export 'src/components/template/details.dart';
export 'src/components/template/list_view.dart';
export 'src/components/template/simple_table.dart';

// Widget components exports
export 'src/components/widget/attachment.dart';
export 'src/components/widget/todo.dart';
export 'src/components/widget/case_history.dart';
export 'src/components/widget/followers.dart';
export 'src/components/widget/file_utility.dart';
export 'src/components/widget/summary_item.dart';
export 'src/components/widget/summary_list.dart';

// Infra components exports
export 'src/components/infra/assignment.dart';
export 'src/components/infra/assignment_card.dart';
export 'src/components/infra/region.dart';
export 'src/components/infra/view.dart';
export 'src/components/infra/root_container.dart';
export 'src/components/infra/error_boundary.dart';
export 'src/components/infra/nav_bar.dart';
export 'src/components/infra/stages.dart';
export 'src/components/infra/action_buttons.dart';
export 'src/components/infra/multi_step.dart';

// Design system extension exports
export 'src/components/design_system_extension/field_value_list.dart';
export 'src/components/design_system_extension/field_group.dart';
export 'src/components/design_system_extension/alert_banner.dart';
export 'src/components/design_system_extension/banner.dart';
export 'src/components/design_system_extension/operator.dart';

// Helper exports
export 'src/components/helpers/utils.dart';
export 'src/components/helpers/event_utils.dart';
export 'src/components/helpers/case_utils.dart';
export 'src/components/helpers/date_format_utils.dart';
export 'src/components/helpers/data_page.dart';
