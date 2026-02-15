package com.mobilprogramlar.unitraflow.ui;

import androidx.annotation.NonNull;
import androidx.fragment.app.Fragment;
import androidx.fragment.app.FragmentActivity;
import androidx.viewpager2.adapter.FragmentStateAdapter;

import com.mobilprogramlar.unitraflow.model.Category;

public class CategoryPagerAdapter extends FragmentStateAdapter {

  private final Category[] categories;

  public CategoryPagerAdapter(@NonNull FragmentActivity fa, Category[] categories) {
    super(fa);
    this.categories = categories;
  }

  @NonNull @Override public Fragment createFragment(int position) {
    return UnitConverterFragment.newInstance(categories[position].name());
  }

  @Override public int getItemCount() {
    return categories.length;
  }
}
