
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	ОбновитьПользовательскийИнтерфейс();
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "ИзмененоРабочееМестоТекущегоСеанса" Тогда
		ОбновитьПараметрыРабочегоМеста();
	ИначеЕсли ИмяСобытия = "ИзмененыДоступныеТипыПодключаемогоОборудования" Тогда
		ОбновитьПользовательскийИнтерфейс();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	
	Если Модифицированность Тогда
		
		Если ЗавершениеРаботы Тогда
			Отказ = Истина;
			Возврат;
		КонецЕсли;
		
		ОбновитьПовторноИспользуемыеЗначения();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ПереключательТиповПриИзменении(Элемент)
	
	СписокУстройств.Отбор.Элементы[0].ПравоеЗначение = ПереключательТиповПО;
	
КонецПроцедуры

&НаКлиенте
Процедура СписокУстройствВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	Если ТипЗнч(ВыбраннаяСтрока) <> Тип("СправочникСсылка.ПодключаемоеОборудование") Тогда
		Если Элементы.СписокУстройств.Развернут(ВыбраннаяСтрока) Тогда
			Элементы.СписокУстройств.Свернуть(ВыбраннаяСтрока);
		Иначе
			Элементы.СписокУстройств.Развернуть(ВыбраннаяСтрока);
		КонецЕсли;

		СтандартнаяОбработка = Ложь;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВсеТипыОборудованияПриИзменении(Элемент)
	
	УстановитьГруппировкуПоВсемТипамОборудования();
	
КонецПроцедуры

&НаКлиенте
Процедура ВсеРабочиеМестаПриИзменении(Элемент)
	
	Элементы.ГруппироватьПоРабочемуМесту.Доступность = ВсеРабочиеМеста;
	СписокУстройств.Группировка.Элементы[0].Использование = ВсеРабочиеМеста И ГруппироватьПоРабочемуМесту;
	
	Если Элементы.СписокУстройств.ТекущаяСтрока <> Неопределено Тогда
		Элементы.СписокУстройств.Развернуть(Элементы.СписокУстройств.ТекущаяСтрока, Истина);
	КонецЕсли;
	
	СписокУстройств.Отбор.Элементы[1].Использование = (Не ВсеРабочиеМеста);
	
	Если НЕ ВсеРабочиеМеста Тогда
		ГруппироватьПоРабочемуМесту = Ложь;
		ГруппироватьПоРабочемуМестуПриИзменении(Элемент);
	КонецЕсли;
	
	Элементы.РабочееМесто.Видимость = ВсеРабочиеМеста;
	
КонецПроцедуры

&НаКлиенте
Процедура ГруппироватьПоРабочемуМестуПриИзменении(Элемент)
	
	СписокУстройств.Группировка.Элементы[0].Использование = ГруппироватьПоРабочемуМесту;
	
	Если Элементы.СписокУстройств.ТекущаяСтрока <> Неопределено Тогда
		Элементы.СписокУстройств.Развернуть(Элементы.СписокУстройств.ТекущаяСтрока, Истина);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовФормы

&НаКлиенте
Процедура СписокУстройствОбработкаЗаписиНового(НовыйОбъект, Источник, СтандартнаяОбработка)
	
	ОбновитьПараметрыРабочегоМеста();
	
	#Если НЕ ВебКлиент Тогда 
	Источник.Прочитать();
	#КонецЕсли 
	
КонецПроцедуры

&НаКлиенте
Процедура СписокУстройствПослеУдаления(Элемент)
	
	ОбновитьПараметрыРабочегоМеста();
	
КонецПроцедуры

&НаКлиенте
Процедура СписокУстройствПриАктивизацииСтроки(Элемент)
	
	Если Элементы.Найти("Настроить") <> Неопределено Тогда
		Элементы.Настроить.Доступность = (ТипЗнч(Элемент.ТекущаяСтрока) = Тип("СправочникСсылка.ПодключаемоеОборудование"));
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ВыборРабочегоМестаЗавершение(Результат, Параметры) Экспорт
	
	Если ТипЗнч(Результат) = Тип("Структура") И Результат.Свойство("РабочееМесто") Тогда 
		МенеджерОборудованияКлиент.УстановитьРабочееМесто(Результат.РабочееМесто);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВыборРабочегоМеста(Команда)
	
	Оповещение = Новый ОписаниеОповещения("ВыборРабочегоМестаЗавершение", ЭтотОбъект);
	МенеджерОборудованияКлиент.ПредложитьВыборРабочегоМеста(Оповещение);
	
КонецПроцедуры

&НаКлиенте
Процедура НастроитьВыполнить()
	
	ОчиститьСообщения();
	СообщениеОбОшибке = "";
	
	Если Элементы.СписокУстройств.ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	МенеджерОборудованияКлиент.ВыполнитьНастройкуОборудования(Элементы.СписокУстройств.ТекущиеДанные.Ссылка);
	
КонецПроцедуры

&НаКлиенте
Процедура СписокРабочихМест(Команда)
	
	Режим = РежимОткрытияОкнаФормы.БлокироватьВесьИнтерфейс;
	ОткрытьФорму("Справочник.РабочиеМеста.ФормаСписка",,,,,,, Режим);
	
КонецПроцедуры

&НаКлиенте
Процедура ДрайверыОборудования(Команда)
	
	ОткрытьФорму("Справочник.ДрайверыОборудования.ФормаСписка");
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура УстановитьГруппировкуПоВсемТипамОборудования(ПринудительноСбросить = Ложь)
	
	Если Не СписокУстройств.Группировка.Элементы.Количество() > 0 Тогда
		Возврат;
	КонецЕсли;
	
	Если ПринудительноСбросить Тогда
		СписокУстройств.Группировка.Элементы[1].Использование = Ложь;
	Иначе
		
		СписокУстройств.Отбор.Элементы[0].Использование = (Не ВсеТипыОборудования);
		
		Элементы.ПереключательТиповПО.Доступность = (Не ВсеТипыОборудования);
		СписокУстройств.Группировка.Элементы[1].Использование = ВсеТипыОборудования; // Группировать по типу оборудования.
		
		Если Элементы.СписокУстройств.ТекущаяСтрока <> Неопределено Тогда
			Элементы.СписокУстройств.Развернуть(Элементы.СписокУстройств.ТекущаяСтрока, Истина);
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура ОбновитьПользовательскийИнтерфейс()
	
	ТекущееРабочееМесто = МенеджерОборудованияВызовСервера.ПолучитьРабочееМестоКлиента();
	
	СписокОборудования = МенеджерОборудованияВызовСервераПереопределяемый.ПолучитьДоступныеТипыОборудования();
	
	Элементы.ПереключательТиповПО.СписокВыбора.Очистить();
	Для Каждого ТипПО Из СписокОборудования Цикл
		Элементы.ПереключательТиповПО.СписокВыбора.Добавить(ТипПО);
	КонецЦикла;
	ПереключательТиповПО = СписокОборудования[0];
	
	Элементы.СписокУстройств.КоманднаяПанель.Видимость = ПравоДоступа("СохранениеДанныхПользователя", Метаданные);
	
	// Предустановленные настройки, которые пользователь не должен видеть и изменять.
	ЭлементГруппировки = СписокУстройств.Группировка.Элементы.Добавить(Тип("ПолеГруппировкиКомпоновкиДанных"));
	ЭлементГруппировки.Поле = Новый ПолеКомпоновкиДанных("РабочееМесто");
	ЭлементГруппировки.Использование = Ложь;
	
	ЭлементГруппировки = СписокУстройств.Группировка.Элементы.Добавить(Тип("ПолеГруппировкиКомпоновкиДанных"));
	ЭлементГруппировки.Поле = Новый ПолеКомпоновкиДанных("ТипОборудования");
	ЭлементГруппировки.Использование = Ложь;
	
	ЭлементОтбора = СписокУстройств.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ЭлементОтбора.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ТипОборудования");
	ЭлементОтбора.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ЭлементОтбора.ПравоеЗначение = ПереключательТиповПО;
	ЭлементОтбора.Использование = Истина;
	
	ЭлементОтбора = СписокУстройств.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ЭлементОтбора.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("РабочееМесто");
	ЭлементОтбора.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ЭлементОтбора.ПравоеЗначение = Неопределено;
	ЭлементОтбора.Использование = Истина;

	ОбновитьПараметрыРабочегоМеста();
	
	Если ОбщегоНазначенияКлиентСервер.ЭтоМобильныйКлиент() Тогда
		Элементы.УправлениеРабочимМестом.Видимость = Ложь;
		Элементы.УправлениеРабочимиМестами.Видимость = Ложь;
		Элементы.РабочееМесто.Видимость = Ложь;
	КонецЕсли;
	
	МенеджерОборудованияВызовСервера.ПодготовитьЭлементУправления(Элементы.ПереключательТиповПО);
	МенеджерОборудованияВызовСервера.ПодготовитьЭлементУправления(Элементы.ВсеТипыОборудования);
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьПараметрыРабочегоМеста()
	
	Если ТекущееРабочееМесто = Справочники.РабочиеМеста.ПустаяСсылка()
		Или ТекущееРабочееМесто <> МенеджерОборудованияВызовСервера.ПолучитьРабочееМестоКлиента() Тогда
			ТекущееРабочееМесто = МенеджерОборудованияВызовСервера.ПолучитьРабочееМестоКлиента();
	КонецЕсли;
	
	Если СписокУстройств.Отбор.Элементы.Количество() > 0 Тогда
		СписокУстройств.Отбор.Элементы[1].ПравоеЗначение = ТекущееРабочееМесто;
	КонецЕсли;
	
	Элементы.РабочееМесто.Видимость = ВсеРабочиеМеста;
	
КонецПроцедуры

#КонецОбласти