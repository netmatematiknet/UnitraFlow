package com.mobilprogramlar.unitraflow.ui;

import android.os.Bundle;
import android.text.Editable;
import android.text.TextWatcher;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ArrayAdapter;
import android.widget.AutoCompleteTextView;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.fragment.app.Fragment;

import com.mobilprogramlar.unitraflow.R;
import com.mobilprogramlar.unitraflow.convert.UnitConverter;
import com.mobilprogramlar.unitraflow.databinding.FragmentUnitConverterBinding;
import com.mobilprogramlar.unitraflow.model.Category;
import com.mobilprogramlar.unitraflow.model.UnitDef;

import java.util.ArrayList;
import java.util.List;
import java.util.Locale;

public class UnitConverterFragment extends Fragment {

  private static final String ARG_CAT = "cat";

  private FragmentUnitConverterBinding b;
  private Category category;

  private List<UnitDef> units = new ArrayList<>();
  private UnitDef fromU;
  private UnitDef toU;

  public static UnitConverterFragment newInstance(String catName) {
    UnitConverterFragment f = new UnitConverterFragment();
    Bundle args = new Bundle();
    args.putString(ARG_CAT, catName);
    f.setArguments(args);
    return f;
  }

  @Nullable @Override public View onCreateView(@NonNull LayoutInflater inflater, @Nullable ViewGroup container, @Nullable Bundle savedInstanceState) {
    b = FragmentUnitConverterBinding.inflate(inflater, container, false);
    return b.getRoot();
  }

  @Override public void onViewCreated(@NonNull View view, @Nullable Bundle savedInstanceState) {
    String catName = getArguments() != null ? getArguments().getString(ARG_CAT, Category.LENGTH.name()) : Category.LENGTH.name();
    category = Category.valueOf(catName);

    units = UnitConverter.units(category);

    setupDropdown(b.acFrom, true);
    setupDropdown(b.acTo, false);

    b.btnSwap.setOnClickListener(v -> {
      UnitDef tmp = fromU;
      fromU = toU;
      toU = tmp;
      if (fromU != null) b.acFrom.setText(fromU.label, false);
      if (toU != null) b.acTo.setText(toU.label, false);
      compute();
    });

    b.etValue.addTextChangedListener(new SimpleTextWatcher(this::compute));
    compute();
  }

  private void setupDropdown(AutoCompleteTextView ac, boolean isFrom) {
    List<String> labels = new ArrayList<>();
    for (UnitDef u : units) labels.add(u.label);

    ArrayAdapter<String> adapter = new ArrayAdapter<>(requireContext(), android.R.layout.simple_list_item_1, labels);
    ac.setAdapter(adapter);

    // default selection
    if (!units.isEmpty()) {
      UnitDef def = units.get(0);
      if (isFrom) fromU = def; else toU = def;
      ac.setText(def.label, false);
    }
    if (units.size() > 1 && !isFrom) {
      toU = units.get(1);
      ac.setText(toU.label, false);
    }

    ac.setOnItemClickListener((parent, view, position, id) -> {
      UnitDef chosen = units.get(position);
      if (isFrom) fromU = chosen; else toU = chosen;
      compute();
    });
  }

  private void compute() {
    if (fromU == null || toU == null) return;

    String raw = b.etValue.getText() != null ? b.etValue.getText().toString().trim() : "";
    if (raw.isEmpty()) {
      b.tvResult.setText("—");
      return;
    }

    // support comma decimals
    raw = raw.replace(",", ".");
    double v;
    try {
      v = Double.parseDouble(raw);
    } catch (Exception e) {
      b.tvResult.setText("—");
      return;
    }

    double out = UnitConverter.convert(category, fromU.id, toU.id, v);
    if (Double.isNaN(out) || Double.isInfinite(out)) {
      b.tvResult.setText("—");
      return;
    }

    b.tvResult.setText(String.format(Locale.US, "%.6f", out).replaceAll("\\.?0+$", ""));
  }

  @Override public void onDestroyView() {
    super.onDestroyView();
    b = null;
  }

  private static class SimpleTextWatcher implements TextWatcher {
    private final Runnable r;
    SimpleTextWatcher(Runnable r) { this.r = r; }
    @Override public void beforeTextChanged(CharSequence s, int start, int count, int after) {}
    @Override public void onTextChanged(CharSequence s, int start, int before, int count) { r.run(); }
    @Override public void afterTextChanged(Editable s) {}
  }
}
