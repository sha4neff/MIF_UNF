
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	УстановитьУсловноеОформление();
	
	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(Объект, ЭтотОбъект);
	
	Элементы.Подразделение.Видимость = ИнтеграцияИС.ИспользоватьПодразделения();
	
	Если Не ЗначениеЗаполнено(Объект.Ссылка) Тогда
		ПриЧтенииСозданииНаСервере();
	КонецЕсли;
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	// СтандартныеПодсистемы.ВерсионированиеОбъектов
	ВерсионированиеОбъектов.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов
	
	СобытияФормИСПереопределяемый.ПриСозданииНаСервере(ЭтотОбъект, Отказ, СтандартнаяОбработка);
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)

	// СтандартныеПодсистемы.УправлениеДоступом
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.УправлениеДоступом") Тогда
		МодульУправлениеДоступом = ОбщегоНазначения.ОбщийМодуль("УправлениеДоступом");
		МодульУправлениеДоступом.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.УправлениеДоступом
	
	ПриЧтенииСозданииНаСервере();
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)

	// СтандартныеПодсистемы.УправлениеДоступом
	УправлениеДоступом.ПослеЗаписиНаСервере(ЭтотОбъект, ТекущийОбъект, ПараметрыЗаписи);
	// Конец СтандартныеПодсистемы.УправлениеДоступом
	
	ОбновитьСтатусГИСМ();
	
	// СтандартныеПодсистемы.УправлениеДоступом
	УправлениеДоступом.ПослеЗаписиНаСервере(ЭтотОбъект, ТекущийОбъект, ПараметрыЗаписи);
	// Конец СтандартныеПодсистемы.УправлениеДоступом
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	Оповестить("#ГИСМ#Запись_МаркировкаТоваровГИСМ",Объект.Основание,Объект.Ссылка);
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	МенеджерОборудованияКлиент.НачатьПодключениеОборудованиеПриОткрытииФормы(Неопределено, ЭтаФорма, "СканерШтрихкода");
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии()
	
	МенеджерОборудованияКлиент.НачатьОтключениеОборудованиеПриЗакрытииФормы(Неопределено, ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "#ГИСМ#ИзменениеСостоянияГИСМ"
		И Параметр.Ссылка = Объект.Ссылка Тогда
		
		ОбновитьСтатусГИСМ();
		
	КонецЕсли;
	
	Если ИмяСобытия = "#ГИСМ#ВыполненОбменГИСМ"
		И (Параметр = Неопределено
		Или (ТипЗнч(Параметр) = Тип("Структура") И Параметр.ОбновлятьСтатусВФормахДокументов)) Тогда
		
		ОбновитьСтатусГИСМ();
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапки

&НаКлиенте
Процедура ОперацияМаркировкиПриИзменении(Элемент)
	
	ОперацияМаркировкиПриИзмененииСервер();
	
КонецПроцедуры

&НаКлиенте
Процедура СтатусГИСМОбработкаНавигационнойСсылки(Элемент, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Если (Не ЗначениеЗаполнено(Объект.Ссылка)) Или (Не Объект.Проведен) Тогда
		
		ОписаниеОповещенияВопрос = Новый ОписаниеОповещения("СтатусГИСМОбработкаНавигационнойСсылкиЗавершение",
		                                                    ЭтотОбъект,
		                                                    Новый Структура("НавигационнаяСсылкаФорматированнойСтроки", НавигационнаяСсылкаФорматированнойСтроки));
		ТекстВопроса = НСтр("ru = 'Маркировка товаров ГИСМ не проведена. Провести?'");
		ПоказатьВопрос(ОписаниеОповещенияВопрос, ТекстВопроса, РежимДиалогаВопрос.ДаНет);
		
	ИначеЕсли Модифицированность Тогда
		
		ОписаниеОповещенияВопрос = Новый ОписаниеОповещения("СтатусГИСМОбработкаНавигационнойСсылкиЗавершение",
		                                                    ЭтотОбъект,
		                                                    Новый Структура("НавигационнаяСсылкаФорматированнойСтроки", НавигационнаяСсылкаФорматированнойСтроки));
		ТекстВопроса = НСтр("ru = 'Маркировка товаров ГИСМ была изменена. Провести?'");
		ПоказатьВопрос(ОписаниеОповещенияВопрос, ТекстВопроса, РежимДиалогаВопрос.ДаНет);
		
	Иначе
		
		ОбработатьНажатиеНавигационнойСсылки(НавигационнаяСсылкаФорматированнойСтроки);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СтатусГИСМОбработкаНавигационнойСсылкиЗавершение(РезультатВопроса, ДополнительныеПараметры) Экспорт
	
	Если Не РезультатВопроса = КодВозвратаДиалога.Да Тогда
		 Возврат;
	КонецЕсли;
	
	Если ПроверитьЗаполнение() Тогда
		Записать();
	КонецЕсли;
	
	Если Не Модифицированность И ЗначениеЗаполнено(Объект.Ссылка) Тогда
		ОбработатьНажатиеНавигационнойСсылки(ДополнительныеПараметры.НавигационнаяСсылкаФорматированнойСтроки);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработатьНажатиеНавигационнойСсылки(НавигационнаяСсылкаФорматированнойСтроки)
	
	Если НавигационнаяСсылкаФорматированнойСтроки = "ПередатьДанные" Тогда
		
		ИнтеграцияГИСМКлиент.ПодготовитьСообщениеКПередаче(
			Объект.Ссылка,
			ПредопределенноеЗначение("Перечисление.ОперацииОбменаГИСМ.ПередачаДанных"));
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура КиЗГИСМВидПриИзменении(Элемент)
	Если МаркировкаТоваровГИСМКлиент.ПроверитьЗаполнениеКатегорийКиЗ(Объект) Тогда
		КатегорияКиЗПриИзменении();
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура КиЗГИСМРазмерПриИзменении(Элемент)
	Если МаркировкаТоваровГИСМКлиент.ПроверитьЗаполнениеКатегорийКиЗ(Объект) Тогда
		КатегорияКиЗПриИзменении();
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура КиЗГИСМСпособВыпускаВОборотПриИзменении(Элемент)
	Если МаркировкаТоваровГИСМКлиент.ПроверитьЗаполнениеКатегорийКиЗ(Объект) Тогда
		КатегорияКиЗПриИзменении();
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура КиЗГИСМСИндивидуализациейПриИзменении(Элемент)
	Если МаркировкаТоваровГИСМКлиент.ПроверитьЗаполнениеКатегорийКиЗ(Объект) Тогда
		КатегорияКиЗПриИзменении();
	КонецЕсли;
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ЗаписатьДокумент(Команда)
	
	ОценкаПроизводительностиКлиент.ЗамерВремени("Документ.МаркировкаТоваровГИСМ.Форма.ФормаДокумента.Записать");
	
	ОчиститьСообщения();
	Записать();
	
КонецПроцедуры

&НаКлиенте
Процедура ПровестиДокумент(Команда)
	
	ОценкаПроизводительностиКлиент.ЗамерВремени("Документ.МаркировкаТоваровГИСМ.Форма.ФормаДокумента.Провести");
	
	ОчиститьСообщения();
	ПараметрыЗаписи = Новый Структура("РежимЗаписи", РежимЗаписиДокумента.Проведение);
	Записать(ПараметрыЗаписи);
	
КонецПроцедуры

&НаКлиенте
Процедура ПровестиИЗакрыть(Команда)
	
	ОценкаПроизводительностиКлиент.ЗамерВремени("Документ.МаркировкаТоваровГИСМ.Форма.ФормаДокумента.ПровестиИЗакрыть");
	
	ОчиститьСообщения();
	ПараметрыЗаписи = Новый Структура("РежимЗаписи", РежимЗаписиДокумента.Проведение);
	
	Если Записать(ПараметрыЗаписи) Тогда
		Закрыть();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыТовары

&НаКлиенте
Процедура ТоварыНоменклатураПриИзменении(Элемент)
	
	ТекущаяСтрока = Элементы.Товары.ТекущиеДанные;
	ИдентификаторСтроки = ТекущаяСтрока.ПолучитьИдентификатор();
	ТоварыНоменклатураПриИзмененииСервер(ИдентификаторСтроки);
	
КонецПроцедуры

&НаКлиенте
Процедура ТоварыХарактеристикаПриИзменении(Элемент)
	ТекущаяСтрока = Элементы.Товары.ТекущиеДанные;
	ИдентификаторСтроки = ТекущаяСтрока.ПолучитьИдентификатор();
	ТоварыХарактеристикаПриИзмененииСервер(ИдентификаторСтроки);
КонецПроцедуры

&НаКлиенте
Процедура ТоварыХарактеристикаСоздание(Элемент, СтандартнаяОбработка)
	
	СобытияФормГИСМКлиентПереопределяемый.ХарактеристикаСоздание(ЭтотОбъект, Элементы.Товары.ТекущиеДанные, Элемент, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура ТоварыGTINПриИзменении(Элемент)
	ТекущаяСтрока = Элементы.Товары.ТекущиеДанные;
	ИдентификаторСтроки = ТекущаяСтрока.ПолучитьИдентификатор();
	ТоварыGTINПриИзмененииСервер(ИдентификаторСтроки);
КонецПроцедуры

&НаКлиенте
Процедура ТоварыGTINНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	ТекущаяСтрока = Элементы.Товары.ТекущиеДанные;
	СписокВыбораGTIN = Новый Массив;
	МаркировкаТоваровГИСМВызовСервераПереопределяемый.МассивGTINМаркированногоТовара(
		ТекущаяСтрока.Номенклатура, ТекущаяСтрока.Характеристика, СписокВыбораGTIN);
	Элемент.СписокВыбора.ЗагрузитьЗначения(СписокВыбораGTIN);
КонецПроцедуры

&НаКлиенте
Процедура ТоварыНоменклатураКиЗНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ТекущаяСтрока = Элементы.Товары.ТекущиеДанные;
	GTIN = ?(Объект.КиЗГИСМСИндивидуализацией, ТекущаяСтрока.GTIN, "");
	СписокВыбораКиЗ = Новый Массив;
	МаркировкаТоваровГИСМВызовСервераПереопределяемый.ОтобратьНоменклатуруПоНомеруGTIN(
		СписокНоменклатураКиЗ, GTIN, СписокВыбораКиЗ);
	Элемент.СписокВыбора.ЗагрузитьЗначения(СписокВыбораКиЗ);
	
КонецПроцедуры

&НаКлиенте
Процедура ТоварыХарактеристикаКиЗСоздание(Элемент, СтандартнаяОбработка)
	
	СобытияФормГИСМКлиентПереопределяемый.ХарактеристикаСоздание(ЭтотОбъект, Элементы.Товары.ТекущиеДанные, Элемент, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура ТоварыКодТаможенногоОрганаПриИзменении(Элемент)
	
	СтрокаТЧ = Элементы.Товары.ТекущиеДанные;
	
	ЗаполнитьХотяБыОдноИзКлючевыхПолейЗаполнено(СтрокаТЧ);
	
КонецПроцедуры

&НаКлиенте
Процедура ТоварыДатаРегистрацииДекларацииПриИзменении(Элемент)
	
	СтрокаТЧ = Элементы.Товары.ТекущиеДанные;
	
	ЗаполнитьХотяБыОдноИзКлючевыхПолейЗаполнено(СтрокаТЧ);
	
КонецПроцедуры

&НаКлиенте
Процедура ТоварыРегистрационныйНомерДекларацииПриИзменении(Элемент)
	
	СтрокаТЧ = Элементы.Товары.ТекущиеДанные;
	
	ЗаполнитьХотяБыОдноИзКлючевыхПолейЗаполнено(СтрокаТЧ);
	
КонецПроцедуры

&НаКлиенте
Процедура ТоварыПриНачалеРедактирования(Элемент, НоваяСтрока, Копирование)
	
	Если НоваяСтрока И Не Копирование Тогда
		
		ТекущиеДанные = Элементы.Товары.ТекущиеДанные;
		
		ЗаполнитьХотяБыОдноИзКлючевыхПолейЗаполнено(ТекущиеДанные);
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ПриЧтенииСозданииНаСервере()
	
	ЗаполнитьОперацияИдентификации();
	
	ОбновитьСтатусГИСМ();
	
	МаркировкаТоваровГИСМПереопределяемый.ЗаполнитьСпискиВыбораРеквизитовШапки(ЭтаФорма);
	МаркировкаТоваровГИСМПереопределяемый.ПолучитьКиЗДляЗаполнения(Объект,СписокНоменклатураКиЗ);
	
	УстановитьКорректностьЗаполненияКлючевыхПолейТовары();
	
	ВидимостьДополнительныхРеквизитовТабличнойЧастиТовары();
	
КонецПроцедуры

&НаСервере
Процедура УстановитьКорректностьЗаполненияКлючевыхПолейТовары()

	Для Каждого СтрокаТЧ Из Объект.Товары Цикл
		ЗаполнитьХотяБыОдноИзКлючевыхПолейЗаполнено(СтрокаТЧ);
	КонецЦикла;

КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура ЗаполнитьХотяБыОдноИзКлючевыхПолейЗаполнено(СтрокаТЧ)

	СтрокаТЧ.ХотяБыОдноИзКлючевыхПолейЗаполнено = (ЗначениеЗаполнено(СтрокаТЧ.КодТаможенногоОргана)
	                                              Или ЗначениеЗаполнено(СтрокаТЧ.ДатаРегистрацииДекларации)
	                                              Или ЗначениеЗаполнено(СтрокаТЧ.РегистрационныйНомерДекларации))
	                                              Или (Не ЗначениеЗаполнено(СтрокаТЧ.КодТаможенногоОргана)
	                                              И Не ЗначениеЗаполнено(СтрокаТЧ.ДатаРегистрацииДекларации)
	                                              И Не ЗначениеЗаполнено(СтрокаТЧ.РегистрационныйНомерДекларации));
	
КонецПроцедуры

#Область ПриИзмененииРеквизитов

&НаСервере
Процедура ОперацияМаркировкиПриИзмененииСервер() 
	
	ЗаполнитьОперацияИдентификации();
	МаркировкаТоваровГИСМ.УправлениеДоступностью(ЭтаФорма);
	
	ВидимостьДополнительныхРеквизитовТабличнойЧастиТовары();
	
КонецПроцедуры

&НаСервере
Процедура ТоварыНоменклатураПриИзмененииСервер(ИдентификаторСтроки)
	
	ТекущаяСтрока = Объект.Товары.НайтиПоИдентификатору(ИдентификаторСтроки);
	МаркировкаТоваровГИСМПереопределяемый.ЗаполнитьGTINВСтроке(ТекущаяСтрока);
	МаркировкаТоваровГИСМПереопределяемый.ЗаполнитьНоменклатуруКиЗВСтроке(ТекущаяСтрока, СписокНоменклатураКиЗ, Объект.КиЗГИСМСИндивидуализацией);
	
КонецПроцедуры

&НаСервере
Процедура ТоварыХарактеристикаПриИзмененииСервер(ИдентификаторСтроки)
	
	ТекущаяСтрока = Объект.Товары.НайтиПоИдентификатору(ИдентификаторСтроки);
	МаркировкаТоваровГИСМПереопределяемый.ЗаполнитьGTINВСтроке(ТекущаяСтрока);
	МаркировкаТоваровГИСМПереопределяемый.ЗаполнитьНоменклатуруКиЗВСтроке(ТекущаяСтрока, СписокНоменклатураКиЗ, Объект.КиЗГИСМСИндивидуализацией);
	
КонецПроцедуры

&НаСервере
Процедура ТоварыGTINПриИзмененииСервер(ИдентификаторСтроки)
	
	ТекущаяСтрока = Объект.Товары.НайтиПоИдентификатору(ИдентификаторСтроки);
	МаркировкаТоваровГИСМПереопределяемый.ЗаполнитьНоменклатуруКиЗВСтроке(ТекущаяСтрока, СписокНоменклатураКиЗ, Объект.КиЗГИСМСИндивидуализацией);
	
КонецПроцедуры

// СтандартныеПодсистемы.ПодключаемыеКоманды
// @skip-warning
&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду(Команда)
	ПодключаемыеКомандыКлиент.ВыполнитьКоманду(ЭтотОбъект, Команда, Объект);
КонецПроцедуры

// @skip-warning
&НаСервере
Процедура Подключаемый_ВыполнитьКомандуНаСервере(Контекст, Результат) Экспорт
	ПодключаемыеКоманды.ВыполнитьКоманду(ЭтотОбъект, Контекст, Объект, Результат);
КонецПроцедуры

// @skip-warning
&НаКлиенте
Процедура Подключаемый_ОбновитьКоманды()
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
КонецПроцедуры
// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

#КонецОбласти

&НаСервере
Процедура ЗаполнитьОперацияИдентификации()
	ОперацияИдентификации = Объект.ОперацияМаркировки = ПредопределенноеЗначение("Перечисление.ОперацииМаркировкиГИСМ.ИдентификацияРанееМаркированнойНаПроизводствеПродукции")
		ИЛИ Объект.ОперацияМаркировки = ПредопределенноеЗначение("Перечисление.ОперацииМаркировкиГИСМ.ИдентификацияРанееМаркированныхПриИмпортеТоваров");
КонецПроцедуры

&НаСервере
Процедура КатегорияКиЗПриИзменении()
	МаркировкаТоваровГИСМПереопределяемый.КатегорияКиЗПриИзменении(Объект, СписокНоменклатураКиЗ);
КонецПроцедуры

&НаСервере
Процедура УстановитьУсловноеОформление()
	
	УсловноеОформление.Элементы.Очистить();
	
	//
	
	//
	
	Элемент = УсловноеОформление.Элементы.Добавить();
	
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ТоварыКодТаможенногоОргана.Имя);
	
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ТоварыДатаРегистрацииДекларации.Имя);
	
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ТоварыРегистрационныйНомерДекларации.Имя);
	
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Объект.Товары.ХотяБыОдноИзКлючевыхПолейЗаполнено");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Истина;
	
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Объект.Товары.КодТаможенногоОргана");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.НеЗаполнено;
	
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Объект.Товары.ДатаРегистрацииДекларации");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.НеЗаполнено;
	
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Объект.Товары.РегистрационныйНомерДекларации");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.НеЗаполнено;
	
	Элемент.Оформление.УстановитьЗначениеПараметра("ОтметкаНезаполненного", Ложь);
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьСтатусГИСМ()
	
	МаркировкаТоваровГИСМ.ОбновитьСтатусГИСМ(ЭтаФорма, "МаркировкаТоваровГИСМ");
	
КонецПроцедуры

&НаСервере
Процедура ВидимостьДополнительныхРеквизитовТабличнойЧастиТовары()
	
	ВидимостьРеквизитов = (Объект.ОперацияМаркировки = Перечисления.ОперацииМаркировкиГИСМ.МаркировкаОстатковНа12082016);
	
	Если ИнтеграцияГИСМ.ИспользоватьВозможностиВерсии("2.41") Тогда
		Элементы.ТоварыКодТаможенногоОргана.Видимость                 = ВидимостьРеквизитов;
		Элементы.ТоварыДатаРегистрацииДекларации.Видимость            = ВидимостьРеквизитов;
	Иначе
		Элементы.ТоварыКодТаможенногоОргана.Видимость                 = Ложь;
		Элементы.ТоварыДатаРегистрацииДекларации.Видимость            = Ложь;
	КонецЕсли;
	
	Элементы.ТоварыНомерТовараВДекларации.Видимость         = ВидимостьРеквизитов;
	Элементы.ТоварыРегистрационныйНомерДекларации.Видимость = ВидимостьРеквизитов;
	
КонецПроцедуры

#КонецОбласти