///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2020, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	УстановитьУсловноеОформление();
	
	НастройкиОтображения = ТекущиеДелаСлужебный.СохраненныеНастройкиОтображения();
	ЗаполнитьДеревоДел(НастройкиОтображения);
	УстановитьПорядокРазделов(НастройкиОтображения);
	
	НастройкиАвтообновления = ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить("ТекущиеДела", "НастройкиАвтообновления");
	Если ТипЗнч(НастройкиАвтообновления) = Тип("Структура") Тогда
		НастройкиАвтообновления.Свойство("АвтообновлениеВключено", ИспользоватьАвтообновление);
		НастройкиАвтообновления.Свойство("ПериодАвтообновления", ПериодОбновления);
	Иначе
		ПериодОбновления = 5;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ДеревоОтображаемыхДелПриИзменении(Элемент)
	
	Модифицированность = Истина;
	Если Элемент.ТекущиеДанные.ЭтоРаздел Тогда
		Для Каждого Дело Из Элемент.ТекущиеДанные.ПолучитьЭлементы() Цикл
			Дело.Пометка = Элемент.ТекущиеДанные.Пометка;
		КонецЦикла;
	ИначеЕсли Элемент.ТекущиеДанные.Пометка Тогда
		Элемент.ТекущиеДанные.ПолучитьРодителя().Пометка = Истина;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура КнопкаОК(Команда)
	
	Если Не ПроверитьЗаполнение() Тогда
		Возврат;
	КонецЕсли;
	
	СохранитьНастройки();
	
	Если АвтообновлениеВключено Тогда
		Оповестить("ТекущиеДела_ВключеноАвтообновление");
	ИначеЕсли АвтообновлениеВыключено Тогда
		Оповестить("ТекущиеДела_ВыключеноАвтообновление");
	КонецЕсли;
	
	Закрыть(Модифицированность);
	
КонецПроцедуры

&НаКлиенте
Процедура КнопкаОтмена(Команда)
	Закрыть(Ложь);
КонецПроцедуры

&НаКлиенте
Процедура ПереместитьВверх(Команда)
	
	Модифицированность = Истина;
	// Перемещение текущей строки на 1 позицию вверх.
	ТекущаяСтрокаДерева = Элементы.ДеревоОтображаемыхДел.ТекущиеДанные;
	
	Если ТекущаяСтрокаДерева.ЭтоРаздел Тогда
		РазделыДерева = ДеревоОтображаемыхДел.ПолучитьЭлементы();
	Иначе
		РодительДела = ТекущаяСтрокаДерева.ПолучитьРодителя();
		РазделыДерева= РодительДела.ПолучитьЭлементы();
	КонецЕсли;
	
	ИндексТекущейСтроки = ТекущаяСтрокаДерева.Индекс;
	Если ИндексТекущейСтроки = 0 Тогда
		Возврат; // Текущая строка вверху списка, не перемещаем.
	КонецЕсли;
	РазделыДерева.Сдвинуть(ТекущаяСтрокаДерева.Индекс, -1);
	ТекущаяСтрокаДерева.Индекс = ИндексТекущейСтроки - 1;
	// Изменение индекса предыдущей строки.
	ПредыдущаяСтрока = РазделыДерева.Получить(ИндексТекущейСтроки);
	ПредыдущаяСтрока.Индекс = ИндексТекущейСтроки;
	Если ПредыдущаяСтрока.Скрытое Тогда
		ПереместитьВверх(Неопределено);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПереместитьВниз(Команда)
	
	Модифицированность = Истина;
	// Перемещение текущей строки на 1 позицию вниз.
	ТекущаяСтрокаДерева = Элементы.ДеревоОтображаемыхДел.ТекущиеДанные;
	
	Если ТекущаяСтрокаДерева.ЭтоРаздел Тогда
		РазделыДерева = ДеревоОтображаемыхДел.ПолучитьЭлементы();
	Иначе
		РодительДела = ТекущаяСтрокаДерева.ПолучитьРодителя();
		РазделыДерева= РодительДела.ПолучитьЭлементы();
	КонецЕсли;
	
	ИндексТекущейСтроки = ТекущаяСтрокаДерева.Индекс;
	Если ИндексТекущейСтроки = (РазделыДерева.Количество() -1) Тогда
		Возврат; // Текущая строка внизу списка, не перемещаем.
	КонецЕсли;
	РазделыДерева.Сдвинуть(ТекущаяСтрокаДерева.Индекс, 1);
	ТекущаяСтрокаДерева.Индекс = ИндексТекущейСтроки + 1;
	// Изменение индекса следующей строки.
	СледующаяСтрока = РазделыДерева.Получить(ИндексТекущейСтроки);
	СледующаяСтрока.Индекс = ИндексТекущейСтроки;
	Если СледующаяСтрока.Скрытое Тогда
		ПереместитьВниз(Неопределено);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СнятьФлажки(Команда)
	
	Модифицированность = Истина;
	Для Каждого СтрокаРаздела Из ДеревоОтображаемыхДел.ПолучитьЭлементы() Цикл
		СтрокаРаздела.Пометка = Ложь;
		Для Каждого СтрокаДела Из СтрокаРаздела.ПолучитьЭлементы() Цикл
			СтрокаДела.Пометка = Ложь;
		КонецЦикла;
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьФлажки(Команда)
	
	Модифицированность = Истина;
	Для Каждого СтрокаРаздела Из ДеревоОтображаемыхДел.ПолучитьЭлементы() Цикл
		СтрокаРаздела.Пометка = Истина;
		Для Каждого СтрокаДела Из СтрокаРаздела.ПолучитьЭлементы() Цикл
			СтрокаДела.Пометка = Истина;
		КонецЦикла;
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ДублироватьВЦентреОповещений(Команда)
	
	ТекущиеДанные = Элементы.ДеревоОтображаемыхДел.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если ТекущиеДанные.ЭтоРаздел Тогда
		Сообщение = НСтр("ru = 'Выберите дело, а не раздел.'");
		ПоказатьПредупреждение(, Сообщение);
		Возврат;
	КонецЕсли;
	
	ТекущиеДанные.ВыводитьВОповещениях = Не ТекущиеДанные.ВыводитьВОповещениях;
	Если ТекущиеДанные.ВыводитьВОповещениях Тогда
		ТекущиеДанные.Картинка = БиблиотекаКартинок.Оповещения;
	Иначе
		ТекущиеДанные.Картинка = Неопределено;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ЗаполнитьДеревоДел(НастройкиОтображения)
	
	ТекущиеДела   = ПолучитьИзВременногоХранилища(Параметры.ТекущиеДела);
	СтарыеНастройкиОтображения = ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить("ТекущиеДела", "НастройкиОтображения");
	Если СтарыеНастройкиОтображения = Неопределено
		Или ТипЗнч(СтарыеНастройкиОтображения) <> Тип("Структура")
		Или Не СтарыеНастройкиОтображения.Свойство("ДеревоДел") Тогда
		СохраненноеДеревоДел = Неопределено;
	Иначе
		СохраненноеДеревоДел = СтарыеНастройкиОтображения.ДеревоДел; // ДеревоЗначений
	КонецЕсли;
	Если СохраненноеДеревоДел = Неопределено Тогда
		ДеревоДел = РеквизитФормыВЗначение("ДеревоОтображаемыхДел");
	Иначе
		ДеревоДел = СохраненноеДеревоДел;
	КонецЕсли;
	ДеревоДел.Колонки.Добавить("Проверка", Новый ОписаниеТипов("Булево"));
	Если ДеревоДел.Колонки.Найти("ВыводитьВОповещениях") = Неопределено Тогда
		ДеревоДел.Колонки.Добавить("ВыводитьВОповещениях", Новый ОписаниеТипов("Булево"));
		ДеревоДел.Колонки.Добавить("Скрытое", Новый ОписаниеТипов("Булево"));
		ДеревоДел.Колонки.Добавить("Картинка", Новый ОписаниеТипов("Картинка"));
	КонецЕсли;
	ТекущийРаздел = "";
	Индекс        = 0;
	ИндексДела    = 0;
	СтрокаДерева  = Неопределено;
	
	Если НастройкиОтображения = Неопределено Тогда
		ТекущиеДелаСлужебный.УстановитьНачальныйПорядокРазделов(ТекущиеДела);
	КонецЕсли;
	
	Для Каждого Дело Из ТекущиеДела Цикл
		
		Если Дело.ЭтоРаздел
			И ТекущийРаздел <> Дело.ИдентификаторВладельца Тогда
			Если СтрокаДерева <> Неопределено Тогда
				ОтборСтрок = Новый Структура;
				ОтборСтрок.Вставить("Скрытое", Ложь);
				НеСкрытые = СтрокаДерева.Строки.НайтиСтроки(ОтборСтрок);
				СтрокаДерева.Скрытое = (НеСкрытые.Количество() = 0);
			КонецЕсли;
			
			СтрокаДерева = ДеревоДел.Строки.Найти(Дело.ИдентификаторВладельца, "Идентификатор");
			Если СтрокаДерева = Неопределено Тогда
				СтрокаДерева = ДеревоДел.Строки.Добавить();
				СтрокаДерева.Представление = Дело.ПредставлениеРаздела;
				СтрокаДерева.Идентификатор = Дело.ИдентификаторВладельца;
				СтрокаДерева.ЭтоРаздел     = Истина;
				СтрокаДерева.Пометка       = Истина;
				СтрокаДерева.Индекс        = Индекс;
				
				Если НастройкиОтображения <> Неопределено Тогда
					ВидимостьРаздела = НастройкиОтображения.ВидимостьРазделов[СтрокаДерева.Идентификатор];
					Если ВидимостьРаздела <> Неопределено Тогда
						СтрокаДерева.Пометка = ВидимостьРаздела;
					КонецЕсли;
				КонецЕсли;
				Индекс = Индекс + 1;
			Иначе
				Индекс = СтрокаДерева.Индекс;
			КонецЕсли;
			ИндексДела = 0;
			СтрокаДерева.Проверка = Истина;
		ИначеЕсли Не Дело.ЭтоРаздел Тогда
			ДелоРодитель = ДеревоДел.Строки.Найти(Дело.ИдентификаторВладельца, "Идентификатор", Истина);
			Если ДелоРодитель = Неопределено Тогда
				Продолжить;
			КонецЕсли;
			ДелоРодитель.РасшифровкаДела = ДелоРодитель.РасшифровкаДела + ?(ПустаяСтрока(ДелоРодитель.РасшифровкаДела), "", Символы.ПС) + Дело.Представление;
			Продолжить;
		КонецЕсли;
		
		СтрокаДела = СтрокаДерева.Строки.Найти(Дело.Идентификатор, "Идентификатор");
		Если СтрокаДела = Неопределено Тогда
			СтрокаДела = СтрокаДерева.Строки.Добавить();
			СтрокаДела.Представление = Дело.Представление;
			СтрокаДела.Идентификатор = Дело.Идентификатор;
			СтрокаДела.ЭтоРаздел     = Ложь;
			СтрокаДела.Пометка       = Истина;
			СтрокаДела.Индекс        = ИндексДела;
			СтрокаДела.Скрытое       = Дело.СкрыватьВНастройках;
			СтрокаДела.ВыводитьВОповещениях = Дело.ВыводитьВОповещениях;
			
			Если СтрокаДела.ВыводитьВОповещениях Тогда
				СтрокаДела.Картинка = БиблиотекаКартинок.Оповещения;
			Иначе
				СтрокаДела.Картинка = Неопределено;
			КонецЕсли;
			
			Если НастройкиОтображения <> Неопределено Тогда
				ВидимостьДела = НастройкиОтображения.ВидимостьДел[СтрокаДела.Идентификатор];
				Если ВидимостьДела <> Неопределено Тогда
					СтрокаДела.Пометка = ВидимостьДела;
				КонецЕсли;
			КонецЕсли;
			ИндексДела = ИндексДела + 1;
			
			ТекущийРаздел = Дело.ИдентификаторВладельца;
		Иначе
			ИндексДела = СтрокаДела.Индекс + 1;
		КонецЕсли;
		СтрокаДела.Проверка = Истина;
	КонецЦикла;
	
	ОтборУстаревших = Новый Структура;
	ОтборУстаревших.Вставить("Проверка", Ложь);
	ОтборУстаревших.Вставить("Пометка", Истина);
	ОтборУстаревших.Вставить("ЭтоРаздел", Истина);
	НайденныеСтроки = ДеревоДел.Строки.НайтиСтроки(ОтборУстаревших, Истина);
	Для Каждого НайденнаяСтрока Из НайденныеСтроки Цикл
		ДеревоДел.Строки.Удалить(НайденнаяСтрока);
	КонецЦикла;
	
	ОтборУстаревших.ЭтоРаздел = Ложь;
	НайденныеСтроки = ДеревоДел.Строки.НайтиСтроки(ОтборУстаревших, Истина);
	Для Каждого НайденнаяСтрока Из НайденныеСтроки Цикл
		НайденнаяСтрока.Родитель.Строки.Удалить(НайденнаяСтрока);
	КонецЦикла;
	
	ДеревоДел.Колонки.Удалить("Проверка");
	
	ЗначениеВРеквизитФормы(ДеревоДел, "ДеревоОтображаемыхДел");
	
КонецПроцедуры

&НаСервере
Процедура СохранитьНастройки()
	
	СтарыеНастройкиОтображения = ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить("ТекущиеДела", "НастройкиОтображения");
	СвернутыеРазделы = Неопределено;
	ОтключенныеОбъекты = Новый Соответствие;
	Если ТипЗнч(СтарыеНастройкиОтображения) = Тип("Структура") Тогда
		СтарыеНастройкиОтображения.Свойство("СвернутыеРазделы", СвернутыеРазделы);
		СтарыеНастройкиОтображения.Свойство("ОтключенныеОбъекты", ОтключенныеОбъекты);
	КонецЕсли;
	
	Если ОтключенныеОбъекты = Неопределено Тогда
		ОтключенныеОбъекты = Новый Соответствие;
	КонецЕсли;
	
	Если СвернутыеРазделы = Неопределено Тогда
		СвернутыеРазделы = Новый Соответствие;
	КонецЕсли;
	
	// Сохранение положения и видимости разделов.
	ВидимостьРазделов = Новый Соответствие;
	ВидимостьДел      = Новый Соответствие;
	
	ДеревоДел = РеквизитФормыВЗначение("ДеревоОтображаемыхДел");
	Для Каждого Раздел Из ДеревоДел.Строки Цикл
		ВидимостьРазделов.Вставить(Раздел.Идентификатор, Раздел.Пометка);
		Для Каждого Дело Из Раздел.Строки Цикл
			ВидимостьДел.Вставить(Дело.Идентификатор, Дело.Пометка);
		КонецЦикла;
	КонецЦикла;
	
	Результат = Новый Структура;
	Результат.Вставить("ДеревоДел", ДеревоДел);
	Результат.Вставить("ВидимостьРазделов", ВидимостьРазделов);
	Результат.Вставить("ВидимостьДел", ВидимостьДел);
	Результат.Вставить("СвернутыеРазделы", СвернутыеРазделы);
	Результат.Вставить("ОтключенныеОбъекты", ОтключенныеОбъекты);
	
	ОбщегоНазначения.ХранилищеОбщихНастроекСохранить("ТекущиеДела", "НастройкиОтображения", Результат);
	
	// Сохранение настроек автообновления.
	НастройкиАвтообновления = ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить("ТекущиеДела", "НастройкиАвтообновления");
	
	Если НастройкиАвтообновления = Неопределено Тогда
		НастройкиАвтообновления = Новый Структура;
	Иначе
		Если ИспользоватьАвтообновление Тогда
			АвтообновлениеВключено = НастройкиАвтообновления.АвтообновлениеВключено <> ИспользоватьАвтообновление;
		Иначе
			АвтообновлениеВыключено = НастройкиАвтообновления.АвтообновлениеВключено <> ИспользоватьАвтообновление;
		КонецЕсли;
	КонецЕсли;
	
	НастройкиАвтообновления.Вставить("АвтообновлениеВключено", ИспользоватьАвтообновление);
	НастройкиАвтообновления.Вставить("ПериодАвтообновления", ПериодОбновления);
	
	ОбщегоНазначения.ХранилищеОбщихНастроекСохранить("ТекущиеДела", "НастройкиАвтообновления", НастройкиАвтообновления);
	
КонецПроцедуры

&НаСервере
Процедура УстановитьПорядокРазделов(НастройкиОтображения)
	
	Если НастройкиОтображения = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ДеревоДел = РеквизитФормыВЗначение("ДеревоОтображаемыхДел");
	Разделы   = ДеревоДел.Строки;
	СохраненноеДеревоДел = НастройкиОтображения.ДеревоДел;
	Для Каждого СтрокаРаздела Из Разделы Цикл
		СохраненныйРаздел = СохраненноеДеревоДел.Строки.Найти(СтрокаРаздела.Идентификатор, "Идентификатор");
		Если СохраненныйРаздел = Неопределено Тогда
			Продолжить;
		КонецЕсли;
		СтрокаРаздела.Индекс = СохраненныйРаздел.Индекс;
		Дела = СтрокаРаздела.Строки;
		ИндексПоследнегоДела = Дела.Количество() - 1;
		Для Каждого СтрокаДело Из Дела Цикл
			СохраненноеДело = СохраненныйРаздел.Строки.Найти(СтрокаДело.Идентификатор, "Идентификатор");
			Если СохраненноеДело = Неопределено Тогда
				СтрокаДело.Индекс = ИндексПоследнегоДела;
				ИндексПоследнегоДела = ИндексПоследнегоДела - 1;
				Продолжить;
			КонецЕсли;
			СтрокаДело.Индекс = СохраненноеДело.Индекс;
		КонецЦикла;
		Дела.Сортировать("Индекс возр");
	КонецЦикла;
	
	Разделы.Сортировать("Индекс возр");
	ЗначениеВРеквизитФормы(ДеревоДел, "ДеревоОтображаемыхДел");
	
КонецПроцедуры

&НаСервере
Процедура УстановитьУсловноеОформление()
	
	УсловноеОформление.Элементы.Очистить();
	
	//
	Элемент = УсловноеОформление.Элементы.Добавить();
	
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ДеревоОтображаемыхДелПометка.Имя);
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ДеревоОтображаемыхДелПредставление.Имя);
	
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ДеревоОтображаемыхДел.Скрытое");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Истина;
	Элемент.Оформление.УстановитьЗначениеПараметра("Видимость", Ложь);
	
КонецПроцедуры

#КонецОбласти