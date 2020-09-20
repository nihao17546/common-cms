package com.appcnd.common.cms.entity.form.add;

import com.appcnd.common.cms.entity.constant.AddColumnType;
import com.appcnd.common.cms.entity.constant.ElType;
import com.appcnd.common.cms.entity.form.Element;
import lombok.Data;
import lombok.NoArgsConstructor;

/**
 * @author nihao 2019/11/16
 */
@Data
@NoArgsConstructor
public abstract class AddElement extends Element {
    private FormRule rule;
    private AddColumnType columnType;
    private Boolean canEdit;
    private Boolean show = true;

    public AddElement(String key, String label, String placeholder, Boolean clearable, String size, Integer width, ElType elType,
                      FormRule rule, AddColumnType columnType, Boolean canEdit) {
        super(key, label, placeholder, clearable, size, width, elType);
        columnType = columnType == null ? AddColumnType.COM : columnType;
        this.rule = rule;
        this.columnType = columnType;
        this.canEdit = canEdit == null ? true : canEdit;
    }

    @Deprecated
    public static AddCheckBox.AddCheckBoxBuilder checkBox() {
        return AddCheckBox.builder();
    }

    public static AddCreateDateTime.AddCreateDateTimeBuilder createDateTime() {
        return AddCreateDateTime.builder();
    }

    public static AddDatePicker.AddDatePickerBuilder date() {
        return AddDatePicker.builder();
    }

    public static AddDateTimePicker.AddDateTimePickerBuilder datetime() {
        return AddDateTimePicker.builder();
    }

    public static AddInput.AddInputBuilder input() {
        return AddInput.builder();
    }

    public static AddInputNumber.AddInputNumberBuilder inputNumber() {
        return AddInputNumber.builder();
    }

    public static AddRadio.AddRadioBuilder radio() {
        return AddRadio.builder();
    }

    public static AddSelect.AddSelectBuilder select() {
        return AddSelect.builder();
    }

    public static AddSelectRemote.AddSelectRemoteBuilder selectRemote() {
        return AddSelectRemote.builder();
    }

    public static AddTimePicker.AddTimePickerBuilder timePicker() {
        return AddTimePicker.builder();
    }

    public static AddUpdateDateTime.AddUpdateDateTimeBuilder updateDateTime() {
        return AddUpdateDateTime.builder();
    }

    public static AddUploadPic.AddUploadPicBuilder uploadPic() {
        return AddUploadPic.builder();
    }
    public static AddRich.AddRichBuilder rich() {
        return AddRich.builder();
    }
}
