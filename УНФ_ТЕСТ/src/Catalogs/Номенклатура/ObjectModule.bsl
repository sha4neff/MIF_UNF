#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	Если ЭтотОбъект.ЭтоГруппа Тогда
		Возврат;
	КонецЕсли;
	
	Если ТипНоменклатуры = Перечисления.ТипыНоменклатуры.Запас Тогда
		
		ПроверяемыеРеквизиты.Добавить("НаправлениеДеятельности");
		ПроверяемыеРеквизиты.Добавить("СчетУчетаЗатрат");
		ПроверяемыеРеквизиты.Добавить("СчетУчетаЗапасов");
		Если НЕ ЭтоНабор Тогда
			ПроверяемыеРеквизиты.Добавить("МетодОценки");
			ПроверяемыеРеквизиты.Добавить("СпособПополнения");
		КонецЕсли; 
		
	ИначеЕсли ТипНоменклатуры = Перечисления.ТипыНоменклатуры.Услуга Тогда
		
		ПроверяемыеРеквизиты.Добавить("НаправлениеДеятельности");
		ПроверяемыеРеквизиты.Добавить("СчетУчетаЗатрат");
		
	ИначеЕсли ТипНоменклатуры = Перечисления.ТипыНоменклатуры.Работа Тогда
		
		ПроверяемыеРеквизиты.Добавить("НаправлениеДеятельности");
		ПроверяемыеРеквизиты.Добавить("СчетУчетаЗатрат");
		
	ИначеЕсли ТипНоменклатуры = Перечисления.ТипыНоменклатуры.Операция Тогда
		
		ПроверяемыеРеквизиты.Добавить("СчетУчетаЗатрат");
		
	ИначеЕсли ТипНоменклатуры = Перечисления.ТипыНоменклатуры.ПодарочныйСертификат Тогда
		
		ПроверяемыеРеквизиты.Добавить("НаправлениеДеятельности");
		ПроверяемыеРеквизиты.Добавить("СчетУчетаЗатрат");
		ПроверяемыеРеквизиты.Добавить("СчетУчетаЗапасов");
		ПроверяемыеРеквизиты.Добавить("СчетУчетаДоходов");
		Если Не ПроизвольныйНоминал Тогда
			ПроверяемыеРеквизиты.Добавить("Номинал");
		КонецЕсли;
		
	КонецЕсли;
	
	Если НЕ ЭтоГруппа И НЕ ЗначениеЗаполнено(КатегорияНоменклатуры) Тогда
		КатегорияНоменклатуры = Справочники.КатегорииНоменклатуры.БезКатегории;
	КонецЕсли;
	
КонецПроцедуры // ОбработкаПроверкиЗаполнения()

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, ТекстЗаполнения, СтандартнаяОбработка)
	
	Если ДанныеЗаполнения<>Неопределено И ДанныеЗаполнения.Свойство("ЭтоГруппа") И ДанныеЗаполнения.ЭтоГруппа Тогда
		Возврат;
	КонецЕсли;
	
	Если НЕ ЭтоГруппа Тогда
		НаименованиеПолное = ТекстЗаполнения;
	КонецЕсли;
	
	Если ТипЗнч(ДанныеЗаполнения) = Тип("Структура")
		И ДанныеЗаполнения.Свойство("КатегорияНоменклатуры")
		И ЗначениеЗаполнено(ДанныеЗаполнения.КатегорияНоменклатуры) Тогда
		
		Если ОбщегоНазначения.ОбъектЯвляетсяГруппой(ДанныеЗаполнения.КатегорияНоменклатуры) Тогда
			ДанныеЗаполнения.Удалить("КатегорияНоменклатуры");
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ)
	
	// Требуется заполнять служебные свойства в режиме ОбменДанными.Загрузка
	Если ОбменДанными.Загрузка И ДополнительныеСвойства.Свойство("ОтключитьМеханизмРегистрацииОбъектов") Тогда
		Возврат;
	КонецЕсли;
	
	ДатаИзменения = ТекущаяДата();
	
	Если НЕ ЭтоГруппа И ПометкаУдаления = Истина Тогда 
		
		ИсключитьИзПрайсЛистов = Истина;
		
	КонецЕсли;
	
	Если НЕ ЭтоГруппа Тогда
		КатегорииНоменклатурыСервер.ПроверкаЗаполненияСвойствПередЗаписью(ЭтотОбъект, Отказ);
		Если НЕ АлкогольнаяПродукция
			И ЗначениеЗаполнено(ВидАлкогольнойПродукции) Тогда
			АлкогольнаяПродукция = Истина;
		КонецЕсли;
		
	КонецЕсли;
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	// для КиЗ и номенклатуры, которая маркируется КиЗ учет сериный номеров обязателен 
	Если НЕ ЭтоГруппа 
		И (ВидМаркировки = Перечисления.ВидыМаркировки.КонтрольныйИдентификационныйЗнак
			ИЛИ ВидМаркировки = Перечисления.ВидыМаркировки.МаркируемаяПродукция ) Тогда
		
		ИспользоватьСерийныеНомера = Истина;
		
	КонецЕсли;
	
	// для маркировки = киз - ставим, что это КИЗ
	Если НЕ ЭтоГруппа Тогда
		КизГИСМ = (ВидМаркировки = Перечисления.ВидыМаркировки.КонтрольныйИдентификационныйЗнак);
	КонецЕсли;
	
	Если НЕ ЭтоГруппа Тогда
		
		Если ТипНоменклатуры<>Перечисления.ТипыНоменклатуры.ВидРабот
			И ТипНоменклатуры<>Перечисления.ТипыНоменклатуры.Операция
			И ТипНоменклатуры<>Перечисления.ТипыНоменклатуры.Работа
			И НЕ ФиксированнаяСтоимость Тогда
			ФиксированнаяСтоимость = Истина;
		КонецЕсли;
		
		Если ТипНоменклатуры = Перечисления.ТипыНоменклатуры.ВидРабот
			ИЛИ ТипНоменклатуры = Перечисления.ТипыНоменклатуры.Операция
			ИЛИ ТипНоменклатуры = Перечисления.ТипыНоменклатуры.ПодарочныйСертификат
			Тогда
			ИспользоватьХарактеристики = Ложь;
			ПроверятьЗаполнениеХарактеристики = Ложь;
			ПроверятьЗаполнениеПартий = Ложь;
		КонецЕсли;
		
		Если Не ТипНоменклатуры = Перечисления.ТипыНоменклатуры.Запас Тогда
			ИспользоватьПартии = Ложь;
		КонецЕсли;
		
		ПроверятьЗаполнениеХарактеристики = ?(Не ИспользоватьХарактеристики, Ложь, ПроверятьЗаполнениеХарактеристики);
		ПроверятьЗаполнениеПартий = ?(Не ИспользоватьПартии, Ложь, ПроверятьЗаполнениеПартий);
		
	КонецЕсли;
	
	Если НЕ ЭтоГруппа Тогда
		РегистрыСведений.ОбъектыИнтеграцииCRM.ПередЗаписьюОбъекта(ЭтотОбъект);
	КонецЕсли;
	
	Если ЭтотОбъект.ПометкаУдаления И НЕ Отказ Тогда
		УдалитьЗаписиШтрихКодовВСтаромРегистре();
	КонецЕсли;
	
КонецПроцедуры

Процедура ПриКопировании(ОбъектКопирования)
	
	Если НЕ ОбъектКопирования.ЭтоГруппа Тогда
		
		ФайлКартинки = Справочники.НоменклатураПрисоединенныеФайлы.ПустаяСсылка();
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	
	// Требуется заполнять служебные свойства в режиме ОбменДанными.Загрузка
	Если ОбменДанными.Загрузка И ДополнительныеСвойства.Свойство("ОтключитьМеханизмРегистрацииОбъектов") Тогда
		Возврат;
	КонецЕсли;
	
	Если НЕ ЭтоГруппа Тогда
		КатегорииНоменклатурыСервер.ПроверкаЗаполненияСвойствПриЗаписи(ЭтотОбъект, КатегорияНоменклатуры, Отказ);
	КонецЕсли;
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Если ЭтоГруппа Тогда
		ЗаписатьГруппуВРегистр();
		Возврат;
	КонецЕсли;
	
	Если ЭтоНабор Тогда
		Если ИспользоватьХарактеристики Тогда
			УдалитьХарактеристикуПоУмолчанию();
		Иначе
			ОчисткаОбщегоСоставаНабора();
		КонецЕсли;
	КонецЕсли;
	
	РегистрыСведений.ОбъектыИнтеграцииCRM.ПриЗаписиОбъекта(ЭтотОбъект);
	
КонецПроцедуры

Процедура ПередУдалением(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	Конецесли;
	
	Если ЭтоГруппа Тогда
		Возврат;
	КонецЕсли;
	
	Если Отказ Тогда
		Возврат;
	КонецЕсли;
	
	УзелТовары = ОбменСКассовымСерверомШтрихМПереопределяемый.УзелТовары();
	
	ПланыОбмена.УдалитьРегистрациюИзменений(УзелТовары, Ссылка);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура УдалитьЗаписиШтрихКодовВСтаромРегистре()
	
	Если Не ЗначениеЗаполнено(Ссылка) Или Не Константы.МиграцияШтрихкодовВыполнена.Получить() Тогда
		Возврат;
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	
	Запрос.Текст =
	"ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	УдалитьШтрихкодыНоменклатуры.Штрихкод КАК Штрихкод
	|ИЗ
	|	РегистрСведений.УдалитьШтрихкодыНоменклатуры КАК УдалитьШтрихкодыНоменклатуры
	|ГДЕ
	|	УдалитьШтрихкодыНоменклатуры.Номенклатура = &Ссылка";
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	НаборЗаписейУдалитьШтрихкодыНоменклатуры = РегистрыСведений.УдалитьШтрихкодыНоменклатуры.СоздатьНаборЗаписей();
	
	Пока Выборка.Следующий() Цикл
		НаборЗаписейУдалитьШтрихкодыНоменклатуры.Отбор.ШтрихКод.Установить(Выборка.Штрихкод);
		НаборЗаписейУдалитьШтрихкодыНоменклатуры.Записать();
	КонецЦикла;
	
	
КонецПроцедуры

Процедура ЗаписатьГруппуВРегистр()
	
	НаборЗаписей = РегистрыСведений.ИерархияНоменклатуры.СоздатьНаборЗаписей();
	НаборЗаписей.Отбор.Номенклатура.Установить(ЭтотОбъект.Ссылка);
	
	НоваяЗапись = НаборЗаписей.Добавить();
	НоваяЗапись.Номенклатура = ЭтотОбъект.Ссылка;
	НоваяЗапись.ПометкаУдаленияГруппы = ЭтотОбъект.ПометкаУдаления;
	НоваяЗапись.КартинкаГруппы = ?(ЭтотОбъект.ПометкаУдаления, 1, 0);
	
	НаборЗаписей.Записать(Истина);
	
КонецПроцедуры

Процедура ОчисткаОбщегоСоставаНабора()
	
	Запрос = НОвый Запрос;
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	Запрос.Текст =
	"ВЫБРАТЬ ПЕРВЫЕ 1
	|	СоставНаборов.Номенклатура КАК Номенклатура
	|ИЗ
	|	РегистрСведений.СоставНаборов КАК СоставНаборов
	|ГДЕ
	|	СоставНаборов.НоменклатураНабора = &Ссылка
	|	И СоставНаборов.Общий";
	Если НЕ Запрос.Выполнить().Пустой() Тогда
		Набор = РегистрыСведений.СоставНаборов.СоздатьНаборЗаписей();
		Набор.Отбор.НоменклатураНабора.Установить(Ссылка);
		Набор.Отбор.Общий.Установить(Истина);
		Набор.Записать(Истина);
	КонецЕсли; 
	
КонецПроцедуры

//Производит очистку в регистра сведений значение характеристики по умолчанию если номенклатура - Набор
//
Процедура УдалитьХарактеристикуПоУмолчанию()
	
	НаборЗаписей = РегистрыСведений.ЗначенияНоменклатурыПоУмолчанию.СоздатьНаборЗаписей();
	НаборЗаписей.Отбор.Номенклатура.Установить(ЭтотОбъект.Ссылка);
	НаборЗаписей.Записать();
	
КонецПроцедуры

#КонецОбласти 

#КонецЕсли