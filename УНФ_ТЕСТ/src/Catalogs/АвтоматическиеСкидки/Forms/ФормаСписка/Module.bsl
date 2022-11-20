#Область СлужебныеПроцедурыИФункции

#Область СортировкаСписка

// Процедура проверяет установленную сортировку по реквизиту "РеквизитДопУпорядочивания" и предлагает
// установить такую сортировку.
//
&НаКлиенте
Процедура ПроверитьСортировкуСписка()
	
	ПараметрыУстановкиСортировки = Новый Структура;
	ПараметрыУстановкиСортировки.Вставить("СписокРеквизит", Список);
	ПараметрыУстановкиСортировки.Вставить("СписокЭлемент", Элементы.Список);
	
	Если Не СортировкаВСпискеУстановленаПравильно(Список) Тогда
		ТекстВопроса = НСтр("ru = 'Сортировку списка рекомендуется установить
								|по полю ""Порядок"". Настроить необходимую сортировку?'");
		ОписаниеОповещения = Новый ОписаниеОповещения("ПроверитьСписокПередОперациейОтветПоСортировкеПолучен", ЭтотОбъект, ПараметрыУстановкиСортировки);
		Кнопки = Новый СписокЗначений;
		Кнопки.Добавить(КодВозвратаДиалога.Да, НСтр("ru = 'Настроить'"));
		Кнопки.Добавить(КодВозвратаДиалога.Нет, НСтр("ru = 'Не настраивать'"));
		ПоказатьВопрос(ОписаниеОповещения, ТекстВопроса, Кнопки, , КодВозвратаДиалога.Да);
		Возврат;
	КонецЕсли;
	
КонецПроцедуры

// Функция проверяет, что в списке установлена сортировка по реквизиту РеквизитДопУпорядочивания.
//
&НаКлиенте
Функция СортировкаВСпискеУстановленаПравильно(Список)
	
	ПользовательскиеНастройкиПорядка = Неопределено;
	Для Каждого Элемент Из Список.КомпоновщикНастроек.ПользовательскиеНастройки.Элементы Цикл
		Если ТипЗнч(Элемент) = Тип("ПорядокКомпоновкиДанных") Тогда
			ПользовательскиеНастройкиПорядка = Элемент;
			Прервать;
		КонецЕсли;
	КонецЦикла;
	
	Если ПользовательскиеНастройкиПорядка = Неопределено Тогда
		Возврат Истина;
	КонецЕсли;
	
	ЭлементыПорядка = ПользовательскиеНастройкиПорядка.Элементы;
	
	// Найдем первый используемый элемент порядка
	Элемент = Неопределено;
	Для Каждого ЭлементПорядка Из ЭлементыПорядка Цикл
		Если ЭлементПорядка.Использование Тогда
			Элемент = ЭлементПорядка;
			Прервать;
		КонецЕсли;
	КонецЦикла;
	
	Если Элемент = Неопределено Тогда
		// Не установлена никакая сортировка
		Возврат Ложь;
	КонецЕсли;
	
	Если ТипЗнч(Элемент) = Тип("ЭлементПорядкаКомпоновкиДанных") Тогда
		Если Элемент.ТипУпорядочивания = НаправлениеСортировкиКомпоновкиДанных.Возр Тогда
			ПолеРеквизита = Новый ПолеКомпоновкиДанных("РеквизитДопУпорядочивания");
			Если Элемент.Поле = ПолеРеквизита Тогда
				Возврат Истина;
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	
	Возврат Ложь;
	
КонецФункции

// Процедура обрабатывает ответ пользователя на вопрос об установке сортировки по реквизиту РеквизитДопУпорядочивания.
//
&НаКлиенте
Процедура ПроверитьСписокПередОперациейОтветПоСортировкеПолучен(РезультатОтвета, ДополнительныеПараметры) Экспорт
	
	Если РезультатОтвета <> КодВозвратаДиалога.Да Тогда
		Возврат;
	КонецЕсли;
	
	УстановитьСортировкуСпискаПоПолюПорядок();
	
КонецПроцедуры

// Процедура устанавливает сортировку по полю РеквизитДопУпорядочивания.
//
&НаКлиенте
Процедура УстановитьСортировкуСпискаПоПолюПорядок()
	
	СписокРеквизит = Список;
	
	ПользовательскиеНастройкиПорядка = Неопределено;
	Для Каждого Элемент Из СписокРеквизит.КомпоновщикНастроек.ПользовательскиеНастройки.Элементы Цикл
		Если ТипЗнч(Элемент) = Тип("ПорядокКомпоновкиДанных") Тогда
			ПользовательскиеНастройкиПорядка = Элемент;
			Прервать;
		КонецЕсли;
	КонецЦикла;
	
	ОбщегоНазначенияКлиентСервер.Проверить(ПользовательскиеНастройкиПорядка <> Неопределено, НСтр("ru = 'Пользовательская настройка порядка не найдена.'"));
	
	ПользовательскиеНастройкиПорядка.Элементы.Очистить();
	Элемент = ПользовательскиеНастройкиПорядка.Элементы.Добавить(Тип("ЭлементПорядкаКомпоновкиДанных"));
	Элемент.Использование = Истина;
	Элемент.Поле = Новый ПолеКомпоновкиДанных("РеквизитДопУпорядочивания");
	Элемент.ТипУпорядочивания = НаправлениеСортировкиКомпоновкиДанных.Возр;
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#Область ПроцедурыОбработчикиСобытийФормы

// Процедура - обработчик события ПриСозданииНаСервере.
//
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Установка доступности цен для редактирования.
	РазрешеноРедактированиеЦенДокументов = УправлениеНебольшойФирмойУправлениеДоступомПовтИсп.РазрешеноРедактированиеЦенДокументов();
	Элементы.Список.ТолькоПросмотр = НЕ РазрешеноРедактированиеЦенДокументов;
	
	ВариантСовместногоПримененияСкидок = Константы.ВариантыСовместногоПримененияСкидокНаценок.Получить();
	Если ВариантСовместногоПримененияСкидок.Пустая() Тогда
		ВариантСовместногоПримененияСкидок = Перечисления.ВариантыСовместногоПримененияСкидокНаценок.Сложение;
		Константы.ВариантыСовместногоПримененияСкидокНаценок.Установить(ВариантСовместногоПримененияСкидок);
	КонецЕсли;
	
КонецПроцедуры

// Процедура - обработчик события ПриОткрытии.
//
&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	Если ВариантСовместногоПримененияСкидок = ПредопределенноеЗначение("Перечисление.ВариантыСовместногоПримененияСкидокНаценок.Вытеснение")
		ИЛИ ВариантСовместногоПримененияСкидок = ПредопределенноеЗначение("Перечисление.ВариантыСовместногоПримененияСкидокНаценок.Умножение") Тогда
		УстановитьСортировкуСпискаПоПолюПорядок();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

// Процедура - обработчик команды СоздатьГруппуСовместногоПрименения формы.
//
&НаКлиенте
Процедура СоздатьГруппуСовместногоПрименения(Команда)
	
	ПараметрыДляФормыГруппы = Новый Структура("ЭтоГруппа", Истина);
	ОткрытьФорму("Справочник.АвтоматическиеСкидки.ФормаГруппы", ПараметрыДляФормыГруппы,,,,,, РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры

#КонецОбласти

#Область ПроцедурыОбработчикиСобытийЭлементовФормы

// Процедура - обработчик события ПриИзменении элемента ВариантСовместногоПримененияСкидок.
//
&НаКлиенте
Процедура ВариантСовместногоПримененияСкидокПриИзменении(Элемент)
	
	ВариантСовместногоПримененияСкидокПриИзмененииНаСервере(ВариантСовместногоПримененияСкидок);
	Если ВариантСовместногоПримененияСкидок = ПредопределенноеЗначение("Перечисление.ВариантыСовместногоПримененияСкидокНаценок.Вытеснение")
		ИЛИ ВариантСовместногоПримененияСкидок = ПредопределенноеЗначение("Перечисление.ВариантыСовместногоПримененияСкидокНаценок.Умножение") Тогда
		ПроверитьСортировкуСписка();
	КонецЕсли;
	Элементы.Список.Обновить();
	
КонецПроцедуры

// Процедура - обработчик события ПриИзменении элемента ВариантСовместногоПримененияСкидок (серверная часть).
//
&НаСервереБезКонтекста
Процедура ВариантСовместногоПримененияСкидокПриИзмененииНаСервере(ВариантСовместногоПримененияСкидок)
	
	Константы.ВариантыСовместногоПримененияСкидокНаценок.Установить(ВариантСовместногоПримененияСкидок);
	
КонецПроцедуры

#КонецОбласти
