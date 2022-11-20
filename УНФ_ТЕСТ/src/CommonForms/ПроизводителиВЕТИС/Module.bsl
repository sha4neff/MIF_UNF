
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("Производители") Тогда
		Для каждого Строка Из Параметры.Производители Цикл
			ЗаполнитьЗначенияСвойств(Производители.Добавить(), Строка);
		КонецЦикла;
	ИначеЕсли Параметры.Свойство("АдресПроизводители") Тогда
		ТаблицаПроизводители = ПолучитьИзВременногоХранилища(Параметры.АдресПроизводители);
		Для каждого Строка Из ТаблицаПроизводители Цикл
			ЗаполнитьЗначенияСвойств(Производители.Добавить(), Строка);
		КонецЦикла;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Параметры.Продукция) Тогда
		Запрос = Новый Запрос;
		Запрос.УстановитьПараметр("Ссылка", Параметры.Продукция);
		Запрос.Текст = "ВЫБРАТЬ Производитель ИЗ Справочник.ПродукцияВЕТИС.Производители ГДЕ Ссылка = &Ссылка";
		ДоступныеПроизводители = Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("Производитель");
		Если ДоступныеПроизводители.Количество() Тогда
			Элементы.ПроизводителиПроизводитель.СписокВыбора.ЗагрузитьЗначения(ДоступныеПроизводители);
			Элементы.ПроизводителиПроизводитель.РежимВыбораИзСписка = Истина;
			Элементы.ПроизводителиПроизводитель.КнопкаВыбора = Ложь;
		КонецЕсли;
	КонецЕсли;
	
	СтранаПроизводства = Параметры.СтранаПроизводства;
	Если ЗначениеЗаполнено(СтранаПроизводства) Тогда
		ПараметрыВыбора = ОбщегоНазначения.СкопироватьРекурсивно(Элементы.ПроизводителиПроизводитель.СвязиПараметровВыбора, Ложь);
		ПараметрыВыбора.Добавить(Новый ПараметрВыбора("Отбор.СтранаИдентификатор",
			ПрочиеКлассификаторыВЕТИСВызовСервера.ДанныеСтраныМира(СтранаПроизводства).Идентификатор));
		Элементы.ПроизводителиПроизводитель.ПараметрыВыбора = Новый ФиксированныйМассив(ПараметрыВыбора);
	КонецЕсли;
	
	Элементы.ПроизводителиРольПредприятия.СписокВыбора.Добавить(Перечисления.РолиПредприятийВЕТИС.ПустаяСсылка());
	Элементы.ПроизводителиРольПредприятия.СписокВыбора.Добавить(Перечисления.РолиПредприятийВЕТИС.Производитель);
	
	СобытияФормИСПереопределяемый.ПриСозданииНаСервере(ЭтотОбъект, Отказ, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	ИнтеграцияВЕТИСКлиент.ПронумероватьТаблицу(ЭтаФорма, "Производители");
	
	СформироватьЗаголовокФормы();
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	
	Если Модифицированность Тогда
		
		ОписаниеОповещения = Новый ОписаниеОповещения("ПередЗакрытиемЗавершение", ЭтотОбъект);
		
		ПоказатьВопрос(
			ОписаниеОповещения,
			НСтр("ru = 'Данные были изменены. Сохранить изменения?'"),
			РежимДиалогаВопрос.ДаНетОтмена);
		
		Отказ = Истина;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыПроизводители

&НаКлиенте
Процедура ПроизводителиПриОкончанииРедактирования(Элемент, НоваяСтрока, ОтменаРедактирования)
	СформироватьЗаголовокФормы();
	Если Не ОтменаРедактирования Тогда
		ТекущиеДанные = Элементы.Производители.ТекущиеДанные;
		Если Не(ТекущиеДанные = Неопределено) Тогда
			ЗаполнитьПредставленияНомеровПредприятий(ТекущиеДанные.Производитель);
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ПроизводителиПослеУдаления(Элемент)
	СформироватьЗаголовокФормы();
КонецПроцедуры

&НаКлиенте
Процедура ПроизводителиПриИзменении(Элемент)
	
	Модифицированность = Истина;
	
	ИнтеграцияВЕТИСКлиент.ПронумероватьТаблицу(ЭтаФорма, "Производители");
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Готово(Команда)
	
	СохранитьИзменения();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ПередЗакрытиемЗавершение(РезультатВопроса, ДополнительныеПараметры) Экспорт
	
	Если РезультатВопроса = КодВозвратаДиалога.Да Тогда
		СохранитьИзменения();
	ИначеЕсли РезультатВопроса = КодВозвратаДиалога.Нет Тогда
		Модифицированность = Ложь;
		Закрыть();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СохранитьИзменения()
	
	ОчиститьСообщения();
	
	СтруктураПроверяемыхПолей = Новый Структура;
	СтруктураПроверяемыхПолей.Вставить("Производитель");
	
	Если ИнтеграцияВЕТИСКлиент.ПроверитьЗаполнениеТаблицы(ЭтаФорма, "Производители", СтруктураПроверяемыхПолей) Тогда
		Модифицированность = Ложь;
		ОповеститьОВыборе(Производители);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СформироватьЗаголовокФормы()
	
	Заголовок = НСтр("ru = 'Производители'") + ?(Производители.Количество()," ("+Производители.Количество()+")","");
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьПредставленияНомеровПредприятий(Производитель)
	
	Справочники.ПредприятияВЕТИС.ЗаполнитьНомера(Производители, Производитель)
	
КонецПроцедуры


#КонецОбласти