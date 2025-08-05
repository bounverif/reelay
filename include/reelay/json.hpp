/*
 * Copyright (c) 2019-2023 Dogan Ulus
 *
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/.
 */

#pragma once

#include "reelay/datafield.hpp"

#include <boost/json.hpp>

#include <string>
#include <unordered_set>

namespace reelay {

using json = ::boost::json::value;

template<typename T>
struct timefield<T, json> {
  using input_t = json;
  inline static T get_time(const input_t& container)
  {
    return container.as_object().at("time").to_number<T>();
  }
};

template<>
struct datafield<json> {
  using input_t = json;

  inline static input_t at(const input_t& container, const std::string& key)
  {
    return container.as_object().at(key);
  }

  inline static input_t at(const input_t& container, std::size_t index)
  {
    return container.as_array().at(index);
  }

  inline static bool contains(const input_t& container, const std::string& key)
  {
    return container.as_object().contains(key);
  }

  inline static bool as_bool(const input_t& container, const std::string& key)
  {
    return container.as_object().at(key).as_bool();
  }

  inline static int as_integer(const input_t& container, const std::string& key)
  {
    return container.as_object().at(key).get_int64();
  }

  inline static double as_floating(
    const input_t& container, const std::string& key)
  {
    return container.as_object().at(key).get_double();
  }

  inline static std::string as_string(
    const input_t& container, const std::string& key)
  {
    return container.as_object().at(key).get_string().c_str();
  }

  inline static bool contains(const input_t& container, std::size_t index)
  {
    return index < container.as_array().size();
  }

  inline static bool as_bool(const input_t& container, std::size_t index)
  {
    return container.as_array().at(index).as_bool();
  }

  inline static int as_integer(const input_t& container, std::size_t index)
  {
    return container.as_array().at(index).get_int64();
  }

  inline static double as_floating(const input_t& container, std::size_t index)
  {
    return container.as_array().at(index).get_double();
  }

  inline static std::string as_string(
    const input_t& container, std::size_t index)
  {
    return container.as_array().at(index).get_string().c_str();
  }
};

}  // namespace reelay
